import CoreLocation
import Foundation
import KhenshinProtocol
import Combine

@available(iOS 13.0, *)
public class KhipuViewModel: ObservableObject {
    var khipuSocketIOClient: KhipuSocketIOClient? = nil
    @Published var uiState = KhipuUiState()
    private var networkMonitor: NetworkMonitor
    private var cancellables = Set<AnyCancellable>()
    private var locationManager: LocationManager?

    init() {
        self.networkMonitor = NetworkMonitor()
        self.networkMonitor.$isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                self?.uiState.connectedNetwork = isConnected
            }
            .store(in: &cancellables)
    }

    func requestLocation() {
        uiState.geolocationRequested = true
        locationManager?.requestLocation()
    }

    func handleGeolocationRequest(required: Bool) {
        if locationManager == nil {
            locationManager = LocationManager(viewModel: self)
        }
        uiState.geolocationRequired = required

        if !uiState.geolocationRequired {
            self.requestLocation()
        }
    }
    
    func handleLocationUpdate(_ location: CLLocation) {
        uiState.currentLocation = location
        uiState.geolocationAcquired = true
        sendGeolocationResponse(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            accuracy: location.horizontalAccuracy,
            errorCode: nil
        )
    }
    
    func handleLocationError(_ error: Error) {
        sendGeolocationResponse(
            latitude: nil,
            longitude: nil,
            accuracy: nil,
            errorCode: "LOCATION_ERROR"
        )
    }
    
    func handleAuthStatusChange(_ status: CLAuthorizationStatus) {
        uiState.locationAuthStatus = status
        switch status {
        case .denied, .restricted:
            sendGeolocationResponse(
                latitude: nil,
                longitude: nil,
                accuracy: nil,
                errorCode: "PERMISSION_DENIED"
            )
        case .notDetermined:
            break // Wait for user response
        case .authorizedWhenInUse, .authorizedAlways:
            self.requestLocation()
        @unknown default:
            sendGeolocationResponse(
                latitude: nil,
                longitude: nil,
                accuracy: nil,
                errorCode: "UNKNOWN_ERROR"
            )
        }
    }
    
    private func sendGeolocationResponse(latitude: Double?, longitude: Double?, accuracy: Double?, errorCode: String?) {
        do {
            let response = GeolocationResponse(
                accuracy: accuracy,
                errorCode: errorCode,                
                latitude: latitude,
                longitude: longitude,
                type: .geolocationResponse
            )
            print("Geolocation Response: \(try response.jsonString() ?? "Unable to convert to string")")
            
            khipuSocketIOClient?.sendMessage(
                type: MessageType.geolocationResponse.rawValue,
                message: try response.jsonString()!
            )
        } catch {
            print("Error sending geolocation response: \(error)")
        }
    }

    func setKhipuSocketIOClient(serverUrl: String, browserId: String, publicKey: String, appName: String, appVersion: String, locale: String, skipExitPage: Bool, showFooter:Bool, showMerchantLogo:Bool, showPaymentDetails:Bool) {
        if(khipuSocketIOClient == nil) {
            khipuSocketIOClient = KhipuSocketIOClient(serverUrl: serverUrl, browserId: browserId, publicKey: publicKey, appName: appName, appVersion: appVersion, locale: locale, skipExitPage: skipExitPage, showFooter: showFooter, showMerchantLogo: showMerchantLogo, showPaymentDetails: showPaymentDetails, viewModel: self)
        }
    }


    func restartPayment(){
        uiState.bank = ""
        khipuSocketIOClient?.reconnect()
        notifyViewUpdate()
    }

    func notifyViewUpdate() {
        objectWillChange.send()
    }

    func connectClient() {
        khipuSocketIOClient?.connect()
    }

    func disconnectClient() {
        khipuSocketIOClient?.disconnect()
        khipuSocketIOClient = nil
    }

    public func setCurrentProgress(currentProgress: Float){
        uiState.currentProgress=currentProgress
    }

    public func setSiteOperationComplete(type: OperationType, value: String) {
        switch type{
        case OperationType.bankSelected:
            uiState.bank = value
        case OperationType.accountNumberSelected:
            uiState.bankAccountNumber = value
        case OperationType.amountUpdated:
            let operationInfo = OperationInfo(acceptManualTransfer: uiState.operationInfo?.acceptManualTransfer,
                                              amount: value,
                                              body: uiState.operationInfo?.body,
                                              email: uiState.operationInfo?.email,
                                              merchant: uiState.operationInfo?.merchant,
                                              operationID: uiState.operationInfo?.operationID,
                                              subject: uiState.operationInfo?.subject,
                                              type: MessageType.operationInfo,
                                              urls: uiState.operationInfo?.urls,
                                              welcomeScreen: uiState.operationInfo?.welcomeScreen)
            uiState.operationInfo = operationInfo
        case OperationType.personalIdentifier:
            uiState.personalIdentifier = value
        default:
            return
        }
    }

}
