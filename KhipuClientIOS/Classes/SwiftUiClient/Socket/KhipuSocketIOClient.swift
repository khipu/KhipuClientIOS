import Foundation
import UIKit
import SocketIO
import KhenshinSecureMessage
import KhenshinProtocol
import LocalAuthentication
import CoreLocation

@available(iOS 13.0, *)
public class KhipuSocketIOClient: KhipuSocketClientProtocol {
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    private var socketManager: SocketManager?
    private var socket: SocketIOClient?
    private let secureMessage: SecureMessage
    private let KHENSHIN_PUBLIC_KEY: String
    private var receivedMessages: [String]
    private var viewModel: KhipuViewModel
    private var skipExitPage: Bool
    private var skipExitSuccessPage: Bool
    private var showFooter: Bool
    private let locale: String
    private let browserId: String
    private let url: String
    private var connectionCheckerTimer: Timer?
    private var shouldCheckConnection = false
    private var showMerchantLogo: Bool
    private var showPaymentDetails: Bool
    private var hasOpenedAuthorizationApp = false


    @MainActor
    public init(serverUrl url: String, browserId: String, publicKey: String, appName: String, appVersion: String, locale: String, skipExitPage: Bool, skipExitSuccessPage: Bool, showFooter: Bool, showMerchantLogo: Bool, showPaymentDetails: Bool, clientIP: String, viewModel: KhipuViewModel) {
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
        print("Starting a new socket")

        socketManager = SocketManager(socketURL: URL(string: url)!, config: [
            //.log(true),
            .compress,
            .forceNew(true),
            .secure(true),
            .reconnectAttempts(-1),
            .connectParams([
                "clientId": viewModel.clientId,
                "clientPublicKey": secureMessage.publicKeyBase64,
                "locale": locale,
                "userAgent": UAString(),
                "uiType": "payment",
                "browserId": browserId,
                "appName": appName,
                "appVersion": appVersion,
                "appOS": "iOS",
                "capabilities": capabilities,
                "clientIP": clientIP,
                "clientVersion": KhipuVersion.version,
            ])
        ])
        self.receivedMessages = []
        self.socket = socketManager?.defaultSocket
        self.viewModel = viewModel
        self.skipExitPage = skipExitPage
        self.skipExitSuccessPage = skipExitSuccessPage
        self.showFooter = showFooter
        self.showMerchantLogo = showMerchantLogo
        self.showPaymentDetails = showPaymentDetails
        //self.clearKhssCookies()
        self.addListeners()
        self.addParametersUiState()
        //self.startConnectionChecker()
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
                    self.viewModel.setSocketConnected(connected: self.socketManager?.status == .connected)
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

    @MainActor
    private func addListeners() {
        self.socket?.on(clientEvent: .connect) { data, ack in
            print("[id: \(self.viewModel.uiState.operationId)] connected")
            self.viewModel.setSocketConnected(connected: true)
        }

        self.socket?.on(clientEvent: .disconnect) { data, ack in
            let reason = data.first as? String ?? "unknown"
            print("[id: \(self.viewModel.uiState.operationId)] disconnected, reason \(reason)")
            self.hasOpenedAuthorizationApp = false
            self.viewModel.setSocketConnected(connected: false)
        }

        self.socket?.on(clientEvent: .reconnect) { data, ack in
            print("[id: \(self.viewModel.uiState.operationId)] reconnect")
        }

        self.socket?.on(clientEvent: .reconnectAttempt) { data, ack in
            print("[id: \(self.viewModel.uiState.operationId)] reconnectAttempt")
        }

//        self.socket?.onAny { data in
//            self.showCookies()
//        }

        self.socket?.on(MessageType.operationRequest.rawValue) { data, ack in
            print("Received message \(MessageType.operationRequest.rawValue)")
            if (self.isRepeatedMessage(data: data, type: MessageType.operationRequest.rawValue)) {
                return
            }
            self.viewModel.uiState.currentMessageType = MessageType.operationRequest.rawValue
            guard let (decryptedMessage, _) = self.decodeMessage(data, type: MessageType.operationRequest.rawValue) else {
                return
            }
            if(!decryptedMessage.isEmpty) {
                self.sendOperationResponse()
            }
        }

        self.socket?.on(MessageType.authorizationRequest.rawValue) { data, ack in
            print("Received message \(MessageType.authorizationRequest.rawValue)")
            if (self.isRepeatedMessage(data: data, type: MessageType.authorizationRequest.rawValue)) {
                return
            }
            guard let (decryptedMessage, mid) = self.decodeMessage(data, type: MessageType.authorizationRequest.rawValue) else {
                return
            }
            do {
                let authRequest = try AuthorizationRequest(decryptedMessage)
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
            guard let (decryptedMessage, mid) = self.decodeMessage(data, type: MessageType.formRequest.rawValue) else {
                return
            }
            do {
                let formRequest = try FormRequest(decryptedMessage)
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
            
            guard let (decryptedMessage, mid) = self.decodeMessage(data, type: MessageType.openAuthorizationApp.rawValue) else {
                return
            }
            do {
                let openAuthorizationApp = try OpenAuthorizationApp(decryptedMessage)
                self.viewModel.uiState.currentMessageType = MessageType.authorizationRequest.rawValue
                if let schema = openAuthorizationApp.data.ios?.schema,
                   !schema.isEmpty,
                   let appUrl = URL(string: schema) {
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
            guard let (decryptedMessage, mid) = self.decodeMessage(data, type: MessageType.operationFailure.rawValue) else {
                self.finishOperationWithoutDetail(type: MessageType.operationFailure.rawValue, mid: KhipuSocketIOClient.payloadFields(data)?.mid ?? "")
                return
            }
            do {
                let operationFailure = try OperationFailure(decryptedMessage)
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
                print("Error processing \(MessageType.operationFailure.rawValue), mid \(mid)")
                self.finishOperationWithoutDetail(type: MessageType.operationFailure.rawValue, mid: mid)
            }
        }

        self.socket?.on(MessageType.operationInfo.rawValue) { data, ack in
            print("Received message \(MessageType.operationInfo.rawValue)")
            if (self.isRepeatedMessage(data: data, type: MessageType.operationInfo.rawValue)) {
                return
            }
            guard let (decryptedMessage, mid) = self.decodeMessage(data, type: MessageType.operationInfo.rawValue) else {
                return
            }
            do {
                let operationInfo = try OperationInfo(decryptedMessage)
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
            guard let (decryptedMessage, mid) = self.decodeMessage(data, type: MessageType.operationSuccess.rawValue) else {
                self.finishOperationWithoutDetail(type: MessageType.operationSuccess.rawValue, mid: KhipuSocketIOClient.payloadFields(data)?.mid ?? "")
                return
            }
            do {
                let operationSuccess = try OperationSuccess(decryptedMessage)
                self.viewModel.uiState.currentMessageType = MessageType.operationSuccess.rawValue
                self.viewModel.uiState.operationSuccess = operationSuccess
                self.viewModel.uiState.operationFinished=true
                self.viewModel.disconnectClient()
                if(self.skipExitPage || self.skipExitSuccessPage) {
                    self.viewModel.uiState.returnToApp = true
                }
            } catch {
                print("Error processing \(MessageType.operationSuccess.rawValue), mid \(mid)")
                self.finishOperationWithoutDetail(type: MessageType.operationSuccess.rawValue, mid: mid)
            }
        }

        self.socket?.on(MessageType.operationWarning.rawValue) { data, ack in
            print("Received message \(MessageType.operationWarning.rawValue)")
            if (self.isRepeatedMessage(data: data, type: MessageType.operationWarning.rawValue)) {
                return
            }
            guard let (decryptedMessage, mid) = self.decodeMessage(data, type: MessageType.operationWarning.rawValue) else {
                self.finishOperationWithoutDetail(type: MessageType.operationWarning.rawValue, mid: KhipuSocketIOClient.payloadFields(data)?.mid ?? "")
                return
            }
            do {
                let operationWarning = try OperationWarning(decryptedMessage)
                self.viewModel.uiState.currentMessageType = MessageType.operationWarning.rawValue
                self.viewModel.uiState.operationWarning = operationWarning
                self.viewModel.uiState.operationFinished=true
                self.viewModel.disconnectClient()
                if(self.skipExitPage) {
                    self.viewModel.uiState.returnToApp = true
                }
            } catch {
                print("Error processing \(MessageType.operationWarning.rawValue), mid \(mid)")
                self.finishOperationWithoutDetail(type: MessageType.operationWarning.rawValue, mid: mid)
            }
        }

        self.socket?.on(MessageType.operationMustContinue.rawValue) { data, ack in
            print("Received message \(MessageType.operationMustContinue.rawValue)")
            if (self.isRepeatedMessage(data: data, type: MessageType.operationMustContinue.rawValue)) {
                return
            }
            guard let (decryptedMessage, mid) = self.decodeMessage(data, type: MessageType.operationMustContinue.rawValue) else {
                self.finishOperationWithoutDetail(type: MessageType.operationMustContinue.rawValue, mid: KhipuSocketIOClient.payloadFields(data)?.mid ?? "")
                return
            }
            do {
                let operationMustContinue = try OperationMustContinue(decryptedMessage)
                self.viewModel.uiState.currentMessageType = MessageType.operationMustContinue.rawValue
                self.viewModel.uiState.operationMustContinue = operationMustContinue
                self.viewModel.uiState.operationFinished=true
                self.viewModel.disconnectClient()
                if(self.skipExitPage) {
                    self.viewModel.uiState.returnToApp = true
                }
            } catch {
                print("Error processing \(MessageType.operationMustContinue.rawValue), mid \(mid)")
                self.finishOperationWithoutDetail(type: MessageType.operationMustContinue.rawValue, mid: mid)
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
            guard let (decryptedMessage, mid) = self.decodeMessage(data, type: MessageType.progressInfo.rawValue) else {
                return
            }
            do {
                let progressInfo = try ProgressInfo(decryptedMessage)
                self.viewModel.uiState.currentMessageType = MessageType.progressInfo.rawValue
                self.viewModel.uiState.progressInfoMessage = progressInfo.message ?? ""
            } catch {
                print("Error processing progressInfo message, mid \(mid)")
            }
        }

        self.socket?.on(MessageType.translation.rawValue) { data, ack in
            print("Received message \(MessageType.translation.rawValue)")
            if (self.isRepeatedMessage(data: data, type: MessageType.translation.rawValue)) {
                return
            }
            guard let (decryptedMessage, mid) = self.decodeMessage(data, type: MessageType.translation.rawValue) else {
                return
            }
            do {
                let translation = try Translations(decryptedMessage)
                self.viewModel.uiState.currentMessageType = MessageType.translation.rawValue
                if let translations = translation.data {
                    self.viewModel.uiState.translator = KhipuTranslator(translations: translations)
                }
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
            guard let (decryptedMessage, mid) = self.decodeMessage(data, type: MessageType.siteOperationComplete.rawValue) else {
                return
            }
            do {
                let siteOperationComplete = try SiteOperationComplete(decryptedMessage)
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
            
            guard let (decryptedMessage, mid) = self.decodeMessage(data, type: MessageType.geolocationRequest.rawValue) else {
                return
            }
            do {
                let geolocationRequest = try GeolocationRequest(decryptedMessage)
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

    public func disconnect() {
        socket?.disconnect()
        socket?.removeAllHandlers()
        socketManager?.reconnects = false
        socket = nil
        socketManager = nil
    }

    @MainActor
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
                guard let message = try operationResponse.jsonString() else {
                    print("Could not serialize operationResponse")
                    return
                }
                self.sendMessage(type: operationResponse.type.rawValue as String, message: message)
            } else {
                let operationResponse = OperationResponse(
                    fingerprint: nil,
                    operationDescriptor: nil,
                    operationID: self.viewModel.uiState.operationId,
                    sessionCookie: nil,
                    type: MessageType.operationResponse
                )
                guard let message = try operationResponse.jsonString() else {
                    print("Could not serialize operationResponse")
                    return
                }
                self.sendMessage(type: operationResponse.type.rawValue as String, message: message)
            }
        } catch {
            print("Error sending operation response")
        }

    }

    public func sendMessage(type: String, message: String) {
        let encryptedMessage = self.secureMessage.encrypt(plainText: message, receiverPublicKeyBase64: self.KHENSHIN_PUBLIC_KEY)
        socket?.emit(type, encryptedMessage!)
        print("SENDING MESSAGE \(String(describing: (self.viewModel.khipuSocketIOClient as? KhipuSocketIOClient)?.socketManager?.status))")
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
            print("\(cookie.name)=\(cookie.value) \(cookie.domain) \(cookie.expiresDate)")
        }
    }

    /// Extracts and decrypts the `(payload, mid)` pair that every socket message carries.
    ///
    /// Returns nil — never traps — when the frame has an unexpected shape or cannot be
    /// decrypted. `SecureMessage.decrypt` is declared `-> String?`, and force-unwrapping it
    /// is a trap rather than an `Error`, so the `do/catch` around the deserialization never
    /// covered this path: a failed decryption killed the merchant's app.
    private func decodeMessage(_ data: [Any], type: String) -> (message: String, mid: String)? {
        guard let fields = KhipuSocketIOClient.payloadFields(data) else {
            print("Malformed \(type): payload is missing or is not a String")
            return nil
        }
        guard KhipuSocketIOClient.hasDecryptableShape(fields.cipherText) else {
            print("Malformed ciphertext in \(type), mid \(fields.mid): refusing to decrypt")
            return nil
        }
        guard let decryptedMessage = self.secureMessage.decrypt(cipherText: fields.cipherText, senderPublicKey: self.KHENSHIN_PUBLIC_KEY) else {
            print("Could not decrypt \(type), mid \(fields.mid)")
            return nil
        }
        return (decryptedMessage, fields.mid)
    }

    /// Reads the `(cipherText, mid)` pair out of a raw socket frame.
    ///
    /// Split out of `decodeMessage` so the shape handling can be tested without building a
    /// `KhipuSocketIOClient`, whose initializer spins up a `SocketManager` and CoreLocation.
    ///
    /// Every access here used to be a force-cast: `data.first as! String` and `data[1] as! String`.
    /// The second also indexed without checking the count, which is a different failure from a
    /// failed cast and happens before any error handling.
    /// Whether `SecureMessage.decrypt` can be called on this ciphertext without crashing.
    ///
    /// Defends against a precondition the dependency does not check itself.
    /// `SecureMessage._decrypt` does:
    ///
    /// ```swift
    /// let dataParts = cipherText.split(separator: ".")
    /// ... String(dataParts[1])   // no count check
    /// ```
    ///
    /// so a ciphertext with no "." yields a single element and `dataParts[1]` traps with
    /// "Index out of range" — inside the dependency, where a `guard let` on the result
    /// cannot help, because the crash happens before it ever returns. Verified by test:
    /// calling `decrypt` with garbage aborts the process rather than returning nil.
    ///
    /// Fixing this properly belongs in KhenshinSecureMessage; until then we refuse to
    /// hand it input it cannot survive.
    static func hasDecryptableShape(_ cipherText: String) -> Bool {
        return cipherText.split(separator: ".").count >= 2
    }

    static func payloadFields(_ data: [Any]) -> (cipherText: String, mid: String)? {
        guard let cipherText = data.first as? String else {
            return nil
        }
        let mid = data.count > 1 ? (data[1] as? String ?? "") : ""
        return (cipherText, mid)
    }

    /// Ends the operation when a *terminal* message cannot be read.
    ///
    /// The result loses its detail, but the person leaves the flow and the merchant gets its
    /// callback instead of being stranded on a screen with no way out.
    ///
    /// Deliberately does NOT set `currentMessageType`: `KhipuView` force-unwraps
    /// `operationFailure`/`operationSuccess`/`operationWarning`/`operationMustContinue` when it
    /// renders the matching exit screen, so pointing it at a screen whose payload we failed to
    /// build would swap one crash for another. Returning to the app is the only safe exit here.
    private func finishOperationWithoutDetail(type: String, mid: String) {
        print("Unreadable terminal message \(type), mid \(mid): finishing the operation without detail")
        // Recorded so `buildResult` can tell this apart from a cancellation. Without it the
        // merchant is told the payer cancelled, which is a different event entirely.
        self.viewModel.uiState.unprocessableMessageType = type
        self.viewModel.disconnectClient()
        self.viewModel.uiState.operationFinished = true
        self.viewModel.uiState.returnToApp = true
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
