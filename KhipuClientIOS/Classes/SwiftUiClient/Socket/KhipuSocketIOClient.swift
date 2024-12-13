import Foundation
import SocketIO
import KhenshinSecureMessage
import KhenshinProtocol
import LocalAuthentication
import CoreLocation

@available(iOS 13.0, *)
public class KhipuSocketIOClient {
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    private var socketManager: SocketManager?
    private var socket: SocketIOClient?
    private let secureMessage: SecureMessage
    private let KHENSHIN_PUBLIC_KEY: String
    private var receivedMessages: [String]
    private var viewModel: KhipuViewModel
    private var skipExitPage: Bool
    private var showFooter: Bool
    private let locale: String
    private let browserId: String
    private let url: String
    private var connectionCheckerTimer: Timer?
    private var shouldCheckConnection = false
    private var showMerchantLogo: Bool
    private var showPaymentDetails: Bool
    private var hasOpenedAuthorizationApp = false



    public init(serverUrl url: String, browserId: String, publicKey: String, appName: String, appVersion: String, locale: String, skipExitPage: Bool, showFooter: Bool, showMerchantLogo: Bool, showPaymentDetails: Bool, viewModel: KhipuViewModel) {
        self.KHENSHIN_PUBLIC_KEY = publicKey
        self.secureMessage = SecureMessage.init(publicKeyBase64: nil, privateKeyBase64: nil)
        self.locale = locale
        self.browserId = browserId
        self.url = url

        let authStatus: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            authStatus = CLLocationManager().authorizationStatus
        } else {
            authStatus = CLLocationManager.authorizationStatus()
        }
          
        let capabilities = switch authStatus {
            case .notDetermined, .restricted, .denied, 
                 .authorizedWhenInUse, .authorizedAlways:
                "geolocation"
            @unknown default:
                ""
        }

        socketManager = SocketManager(socketURL: URL(string: url)!, config: [
            //.log(true),
            .compress,
            .forceNew(true),
            .secure(false),
            .reconnectAttempts(-1),
            .connectParams([
                "clientId": UUID().uuidString,
                "clientPublicKey": secureMessage.publicKeyBase64,
                "locale": locale,
                "userAgent": UAString(),
                "uiType": "payment",
                "browserId": browserId,
                "appName": appName,
                "appVersion": appVersion,
                "appOS": "iOS",
                "capabilities": capabilities
            ])
        ])
        self.receivedMessages = []
        self.socket = socketManager?.defaultSocket
        self.viewModel = viewModel
        self.skipExitPage = skipExitPage
        self.showFooter = showFooter
        self.showMerchantLogo = showMerchantLogo
        self.showPaymentDetails = showPaymentDetails
        self.clearKhssCookies()
        self.addListeners()
        self.addParametersUiState()
        self.startConnectionChecker()
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)

        print("Current location authorization status: \(authorizationStatusString(authStatus))")
        print("Setting capabilities as: \(capabilities)")
    }

    @objc private func appDidEnterBackground() {
        print("App did enter background. Starting background task...")
        beginBackgroundTask()

        DispatchQueue.main.async {
            self.viewModel.notifyViewUpdate()
        }
    }
    
    @objc private func appWillEnterForeground() {
        print("App will enter foreground. Ending background task...")
        endBackgroundTask()
        
        if socket?.status != .connected {
            print("Socket disconnected, attempting to reconnect.")
            connect()
        } else {
            print("Socket already connected.")
        }
    }

       private func beginBackgroundTask() {
           backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "SocketBackgroundTask") {
               self.endBackgroundTask()
           }
       }

       private func endBackgroundTask() {
           if backgroundTask != .invalid {
               UIApplication.shared.endBackgroundTask(backgroundTask)
               backgroundTask = .invalid
           }
    }

    private func startConnectionChecker() {
        let initialDelay: TimeInterval = 10.0
        connectionCheckerTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if self.shouldCheckConnection {
                    self.viewModel.uiState.connectedSocket = self.socketManager?.status == .connected
                    self.viewModel.notifyViewUpdate()
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + initialDelay) {
            self.shouldCheckConnection = true
        }
    }

    private func addParametersUiState(){
        self.viewModel.uiState.showFooter=self.showFooter
        self.viewModel.uiState.showMerchantLogo=self.showMerchantLogo
        self.viewModel.uiState.showPaymentDetails=self.showPaymentDetails
    }

    private func addListeners() {
        self.socket?.on(clientEvent: .connect) { data, ack in
            print("[id: \(self.viewModel.uiState.operationId)] connected")
        }

        self.socket?.on(clientEvent: .disconnect) { data, ack in
            let reason = data.first as! String
            print("[id: \(self.viewModel.uiState.operationId)] disconnected, reason \(reason)")
            self.hasOpenedAuthorizationApp = false
        }

        self.socket?.on(clientEvent: .reconnect) { data, ack in
            print("[id: \(self.viewModel.uiState.operationId)] reconnect")
        }

        self.socket?.on(clientEvent: .reconnectAttempt) { data, ack in
            print("[id: \(self.viewModel.uiState.operationId)] reconnectAttempt")
        }

        self.socket?.onAny { data in
            //self.showCookies()
        }

        self.socket?.on(MessageType.operationRequest.rawValue) { data, ack in
            print("Received message \(MessageType.operationRequest.rawValue)")
            if (self.isRepeatedMessage(data: data, type: MessageType.operationRequest.rawValue)) {
                return
            }
            self.viewModel.uiState.currentMessageType = MessageType.operationRequest.rawValue
            let decryptedMessage = self.secureMessage.decrypt(cipherText: data.first as! String, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
            if(!decryptedMessage!.isEmpty) {
                self.sendOperationResponse()
            }
        }

        self.socket?.on(MessageType.authorizationRequest.rawValue) { data, ack in
            print("Received message \(MessageType.authorizationRequest.rawValue)")
            if (self.isRepeatedMessage(data: data, type: MessageType.authorizationRequest.rawValue)) {
                return
            }
            let encryptedData = data.first as! String
            let mid = data[1] as! String
            let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
            do {
                let authRequest = try AuthorizationRequest(decryptedMessage!)
                self.viewModel.uiState.currentMessageType = MessageType.authorizationRequest.rawValue
                self.viewModel.uiState.currentAuthorizationRequest = authRequest
            } catch {
                print("Error processing authorizationRequest message, mid \(mid)")
            }
        }

        self.socket?.on(MessageType.cancelOperationComplete.rawValue) { data, ack in
            print("Received message \(MessageType.cancelOperationComplete.rawValue)")
            if (self.isRepeatedMessage(data: data, type: MessageType.cancelOperationComplete.rawValue)) {
                return
            }
            self.viewModel.uiState.currentMessageType = MessageType.cancelOperationComplete.rawValue
        }

        self.socket?.on(MessageType.formRequest.rawValue) { data, ack in
            print("Received message \(MessageType.formRequest.rawValue)")
            if (self.isRepeatedMessage(data: data, type: MessageType.formRequest.rawValue)) {
                return
            }
            let encryptedData = data.first as! String
            let mid = data[1] as! String
            let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
            do {
                let formRequest = try FormRequest(decryptedMessage!)
                self.authAndGetSavedForm(formRequest)
            } catch {
                print("Error processing form message, mid \(mid)")
            }
        }

        self.socket?.on(MessageType.openAuthorizationApp.rawValue) { data, ack in
            print("Received message \(MessageType.openAuthorizationApp.rawValue)")
            
            if self.hasOpenedAuthorizationApp {
                return
            }
            
            if (self.isRepeatedMessage(data: data, type: MessageType.openAuthorizationApp.rawValue)) {
                return
            }
            
            let encryptedData = data.first as! String
            let mid = data[1] as! String
            let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
            do {
                let openAuthorizationApp = try OpenAuthorizationApp(decryptedMessage!)
                self.viewModel.uiState.currentMessageType = MessageType.authorizationRequest.rawValue
                if(!(openAuthorizationApp.data.ios?.schema.isEmpty)!){
                    let appUrl = URL(string: openAuthorizationApp.data.ios!.schema)!
                    if UIApplication.shared.canOpenURL(appUrl)
                    {
                        UIApplication.shared.open(appUrl)
                        self.hasOpenedAuthorizationApp = true
                    }
                }
            } catch {
                print("Error processing form message, mid \(mid)")
            }
        }

        self.socket?.on(MessageType.operationDescriptorInfo.rawValue) { data, ack in
            print("Received message \(MessageType.operationDescriptorInfo.rawValue)")
            if (self.isRepeatedMessage(data: data, type: MessageType.operationDescriptorInfo.rawValue)) {
                return
            }
            self.viewModel.uiState.currentMessageType = MessageType.operationDescriptorInfo.rawValue
        }

        self.socket?.on(MessageType.operationFailure.rawValue) { data, ack in
            print("Received message \(MessageType.operationFailure.rawValue)")
            if (self.isRepeatedMessage(data: data, type: MessageType.operationFailure.rawValue)) {
                return
            }
            let encryptedData = data.first as! String
            let mid = data[1] as! String
            let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
            do {
                let operationFailure = try OperationFailure(decryptedMessage!)
                self.viewModel.uiState.currentMessageType = MessageType.operationFailure.rawValue
                self.viewModel.uiState.operationFailure = operationFailure

                if(self.viewModel.uiState.operationFailure?.reason != FailureReasonType.bankWithoutAutomaton){
                    self.viewModel.disconnectClient()
                    self.viewModel.uiState.operationFinished=true
                }

                if(self.skipExitPage) {
                    self.viewModel.uiState.returnToApp = true
                }
            } catch {
                print("Error processing form message, mid \(mid)")
            }
        }

        self.socket?.on(MessageType.operationInfo.rawValue) { data, ack in
            print("Received message \(MessageType.operationInfo.rawValue)")
            if (self.isRepeatedMessage(data: data, type: MessageType.operationInfo.rawValue)) {
                return
            }
            let encryptedData = data.first as! String
            let mid = data[1] as! String
            let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
            do {
                let operationInfo = try OperationInfo(decryptedMessage!)
                self.viewModel.uiState.currentMessageType = MessageType.operationInfo.rawValue
                self.viewModel.uiState.operationInfo = operationInfo
            } catch {
                print("Error processing form message, mid \(mid)")
            }
        }

        self.socket?.on(MessageType.operationResponse.rawValue) { data, ack in
            print("Received message \(MessageType.operationResponse.rawValue)")
            if (self.isRepeatedMessage(data: data, type: MessageType.operationResponse.rawValue)) {
                return
            }
            self.viewModel.uiState.currentMessageType = MessageType.operationResponse.rawValue
        }

        self.socket?.on(MessageType.operationSuccess.rawValue) { data, ack in
            print("Received message \(MessageType.operationSuccess.rawValue)")
            if (self.isRepeatedMessage(data: data, type: MessageType.operationSuccess.rawValue)) {
                return
            }
            let encryptedData = data.first as! String
            let mid = data[1] as! String
            let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
            do {
                let operationSuccess = try OperationSuccess(decryptedMessage!)
                self.viewModel.uiState.currentMessageType = MessageType.operationSuccess.rawValue
                self.viewModel.uiState.operationSuccess = operationSuccess
                self.viewModel.uiState.operationFinished=true
                self.viewModel.disconnectClient()
                if(self.skipExitPage) {
                    self.viewModel.uiState.returnToApp = true
                }
            } catch {
                print("Error processing form message, mid \(mid)")
            }
        }

        self.socket?.on(MessageType.operationWarning.rawValue) { data, ack in
            print("Received message \(MessageType.operationWarning.rawValue)")
            if (self.isRepeatedMessage(data: data, type: MessageType.operationWarning.rawValue)) {
                return
            }
            let encryptedData = data.first as! String
            let mid = data[1] as! String
            let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
            do {
                let operationWarning = try OperationWarning(decryptedMessage!)
                self.viewModel.uiState.currentMessageType = MessageType.operationWarning.rawValue
                self.viewModel.uiState.operationWarning = operationWarning
                self.viewModel.uiState.operationFinished=true
                self.viewModel.disconnectClient()
                if(self.skipExitPage) {
                    self.viewModel.uiState.returnToApp = true
                }
            } catch {
                print("Error processing form message, mid \(mid)")
            }
        }

        self.socket?.on(MessageType.operationMustContinue.rawValue) { data, ack in
            print("Received message \(MessageType.operationMustContinue.rawValue)")
            if (self.isRepeatedMessage(data: data, type: MessageType.operationMustContinue.rawValue)) {
                return
            }
            let encryptedData = data.first as! String
            let mid = data[1] as! String
            let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
            do {
                let operationMustContinue = try OperationMustContinue(decryptedMessage!)
                self.viewModel.uiState.currentMessageType = MessageType.operationMustContinue.rawValue
                self.viewModel.uiState.operationMustContinue = operationMustContinue
                self.viewModel.uiState.operationFinished=true
                self.viewModel.disconnectClient()
                if(self.skipExitPage) {
                    self.viewModel.uiState.returnToApp = true
                }
            } catch {
                print("Error processing form message, mid \(mid)")
            }
        }

        self.socket?.on(MessageType.preAuthorizationCanceled.rawValue) { data, ack in
            print("Received message \(MessageType.preAuthorizationCanceled.rawValue)")
        }

        self.socket?.on(MessageType.preAuthorizationStarted.rawValue) { data, ack in
            print("Received message \(MessageType.preAuthorizationStarted.rawValue)")
        }

        self.socket?.on(MessageType.progressInfo.rawValue) { data, ack in
            print("Received message \(MessageType.progressInfo.rawValue)")
            if (self.isRepeatedMessage(data: data, type: MessageType.progressInfo.rawValue)) {
                return
            }
            self.hasOpenedAuthorizationApp = false
            let encryptedData = data.first as! String
            let mid = data[1] as! String
            let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
            do {
                let progressInfo = try ProgressInfo(decryptedMessage!)
                self.viewModel.uiState.currentMessageType = MessageType.progressInfo.rawValue
                self.viewModel.uiState.progressInfoMessage = progressInfo.message!
            } catch {
                print("Error processing progressInfo message, mid \(mid)")
            }
        }

        self.socket?.on(MessageType.translation.rawValue) { data, ack in
            print("Received message \(MessageType.translation.rawValue)")
            if (self.isRepeatedMessage(data: data, type: MessageType.translation.rawValue)) {
                return
            }
            let encryptedData = data.first as! String
            let mid = data[1] as! String
            let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
            do {
                let translation = try Translations(decryptedMessage!)
                self.viewModel.uiState.currentMessageType = MessageType.translation.rawValue
                self.viewModel.uiState.translator = KhipuTranslator(translations: translation.data!)
            } catch {
                print("Error processing translation message, mid \(mid)")
            }
        }

        self.socket?.on(MessageType.siteInfo.rawValue) { data, ack in
            print("Received message \(MessageType.siteInfo.rawValue)")
        }

        self.socket?.on(MessageType.siteOperationComplete.rawValue) { data, ack in
            print("Received message \(MessageType.siteOperationComplete.rawValue)")
            if (self.isRepeatedMessage(data: data, type: MessageType.siteOperationComplete.rawValue)) {
                return
            }
            let encryptedData = data.first as! String
            let mid = data[1] as! String
            let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
            do {
                let siteOperationComplete = try SiteOperationComplete(decryptedMessage!)
                self.viewModel.uiState.currentMessageType = MessageType.siteOperationComplete.rawValue
                self.viewModel.setSiteOperationComplete(type: siteOperationComplete.operationType, value: siteOperationComplete.value)
            } catch {
                print("Error processing siteOperationComplete message, mid \(mid)")
            }
        }

        self.socket?.on(MessageType.welcomeMessageShown.rawValue) { data, ack in
            print("Received message \(MessageType.welcomeMessageShown.rawValue)")
        }

        self.socket?.on(MessageType.geolocationRequest.rawValue) { data, ack in
            print("Received message \(MessageType.geolocationRequest.rawValue)")
            if (self.isRepeatedMessage(data: data, type: MessageType.geolocationRequest.rawValue)) {
                print("Skipping repeated message")
                return
            }
            
            let encryptedData = data.first as! String
            let mid = data[1] as! String
            let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
            print("Decrypted GeolocationRequest message: \(decryptedMessage ?? "nil")")
            do {
                let geolocationRequest = try GeolocationRequest(decryptedMessage!)
                print("Parsed geolocation request. Mandatory: \(geolocationRequest.mandatory ?? false)")
                self.viewModel.uiState.currentMessageType = MessageType.geolocationRequest.rawValue
                self.viewModel.handleGeolocationRequest()
            } catch {
                print("Error processing geolocation request message, mid \(mid)")
            }
        }     
    }

    public func connect() {
        socket?.connect()
    }

    func isRepeatedMessage(data: [Any], type: String) -> Bool {
        if let mid = data[1] as? String {
            print("[id: \(self.viewModel.uiState.operationId)] Received message \(type), mid \(mid)")
            if (receivedMessages.contains(mid)) {
                return true
            }
            receivedMessages.append(mid)
        }
        return false
    }

    func disconnect() {
        socket?.disconnect()
        socket?.removeAllHandlers()
        socketManager?.reconnects = false
        socket = nil
        socketManager = nil
    }

    public func reconnect() {
        disconnect()
        socketManager = SocketManager(socketURL: URL(string: url)!, config: [
            .compress,
            .forceNew(true),
            .secure(true),
            .reconnectAttempts(-1),
            .connectParams([
                "clientId": UUID().uuidString,
                "clientPublicKey": secureMessage.publicKeyBase64,
                "locale": locale,
                "userAgent": UAString(),
                "uiType": "payment",
                "browserId": browserId,
                "appName": appName,
                "appVersion": appVersion,
                "appOS": "iOS"
            ])
        ])
        socket = socketManager?.defaultSocket
        addListeners()
        connect()
    }

    func sendOperationResponse() {
        do {
            if (self.viewModel.uiState.operationId.count > 12){
                let operationResponse = OperationResponse(
                    fingerprint: nil,
                    operationDescriptor: self.viewModel.uiState.operationId,
                    operationID: nil,
                    sessionCookie: nil,
                    type: MessageType.operationResponse
                )
                self.sendMessage(type: operationResponse.type.rawValue as String, message: try operationResponse.jsonString()!)
            } else {
                let operationResponse = OperationResponse(
                    fingerprint: nil,
                    operationDescriptor: nil,
                    operationID: self.viewModel.uiState.operationId,
                    sessionCookie: nil,
                    type: MessageType.operationResponse
                )
                self.sendMessage(type: operationResponse.type.rawValue as String, message: try operationResponse.jsonString()!)
            }
        } catch {
            print("Error sending operation response")
        }

    }

    public func sendMessage(type: String, message: String) {
        let encryptedMessage = self.secureMessage.encrypt(plainText: message, receiverPublicKeyBase64: self.KHENSHIN_PUBLIC_KEY)
        socket?.emit(type, encryptedMessage!)
        print("SENDING MESSAGE \(String(describing: self.viewModel.khipuSocketIOClient?.socketManager?.status))")
    }


    func clearKhssCookies() {
        let cookieStorage = HTTPCookieStorage.shared
        let cookies = cookieStorage.cookies!
        for cookie in cookies {
            if (cookie.name == "khss") {
                cookieStorage.deleteCookie(cookie)
            }
        }
    }

    func showCookies() {

        let cookieStorage = HTTPCookieStorage.shared
        //println("policy: \(cookieStorage.cookieAcceptPolicy.rawValue)")

        let cookies = cookieStorage.cookies!
        print("Cookies.count: \(cookies.count)")
        for cookie in cookies {
            print("\(cookie.name)=\(cookie.value) \(cookie.domain)")
        }
    }

    private func authAndGetSavedForm(_ formRequest: FormRequest) -> Void {
        let context = LAContext()
        var error: NSError?
        if (formRequest.rememberValues ?? false && isLoginFormAndStored(formRequest)) {
            if(context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)) {
                let reason = "Confirme su identidad."
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                    DispatchQueue.main.async {
                        if success {
                            self.getSavedForm(formRequest)
                        } else {
                            self.loadForm(formRequest)
                        }
                    }
                }
            } else {
                loadForm(formRequest)
            }
        } else {
            loadForm(formRequest)
        }
    }

    private func getSavedForm(_ formRequest: FormRequest) -> Void {
        do {
            guard let storedCredentials = try CredentialsStorageUtil.searchCredentials(server: self.viewModel.uiState.bank) else {
                throw KeychainError.noPassword
            }
            self.viewModel.uiState.storedUsername = storedCredentials.username
            self.viewModel.uiState.storedPassword = storedCredentials.password
        } catch {
            print("No credentials found for \(self.viewModel.uiState.bank)")
        }
        loadForm(formRequest)
    }

    private func loadForm(_ formRequest: FormRequest) -> Void {
        self.viewModel.uiState.validatedFormItems = formRequest.items.reduce(into: [String: Bool]()) {
            $0[$1.id] = false
        }
        self.viewModel.uiState.currentMessageType = MessageType.formRequest.rawValue
        self.viewModel.uiState.currentForm = formRequest
    }


    private func isLoginFormAndStored(_ formRequest: FormRequest) -> Bool {
        self.viewModel.uiState.storedBankForms.contains(self.viewModel.uiState.bank) && formRequest.items.filter({
            $0.id == "username" || $0.id == "password"
        }).count > 0
    }
}

private func authorizationStatusString(_ status: CLAuthorizationStatus) -> String {
    switch status {
    case .notDetermined:
        return "notDetermined - User has not yet made a choice"
    case .restricted:
        return "restricted - Location services are restricted"
    case .denied:
        return "denied - User denied location access"
    case .authorizedWhenInUse:
        return "authorizedWhenInUse - User allowed location access while app is in use"
    case .authorizedAlways:
        return "authorizedAlways - User allowed location access even in background"
    @unknown default:
        return "unknown status"
    }
}