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

    @MainActor
    func requestLocation() {
        uiState.geolocationRequested = true
        locationManager?.requestLocation()
    }

    func handleGeolocationRequest() {
        if locationManager == nil {
            locationManager = LocationManager(viewModel: self)
        }
    }
    
    @MainActor
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
    }
    
    @MainActor
    func handleAuthStatusChange(_ status: CLAuthorizationStatus) {
        uiState.locationAuthStatus = status
        switch status {
        case .denied, .restricted:
            uiState.geolocationRequested = false
        case .authorizedWhenInUse, .authorizedAlways:
            self.requestLocation()
        case .notDetermined:
            break // Do nothing
        @unknown default:
            break // Do nothing
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
            
            khipuSocketIOClient?.sendMessage(
                type: MessageType.geolocationResponse.rawValue,
                message: try response.jsonString()!
            )
        } catch {
            print("Error sending geolocation response: \(error)")
        }
    }

    @MainActor
    func setKhipuSocketIOClient(serverUrl: String, browserId: String, publicKey: String, appName: String, appVersion: String, locale: String, skipExitPage: Bool, showFooter:Bool, showMerchantLogo:Bool, showPaymentDetails:Bool) {
        if(khipuSocketIOClient == nil) {
            khipuSocketIOClient = KhipuSocketIOClient(serverUrl: serverUrl, browserId: browserId, publicKey: publicKey, appName: appName, appVersion: appVersion, locale: locale, skipExitPage: skipExitPage, showFooter: showFooter, showMerchantLogo: showMerchantLogo, showPaymentDetails: showPaymentDetails, viewModel: self)
        }
    }

    @MainActor
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

    @MainActor
    public func setCurrentProgress(currentProgress: Float){
        uiState.currentProgress=currentProgress
    }

    @MainActor
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
    
    @MainActor
    public func setSocketConnected(connected: Bool){
        uiState.connectedSocket = connected
    }

}
