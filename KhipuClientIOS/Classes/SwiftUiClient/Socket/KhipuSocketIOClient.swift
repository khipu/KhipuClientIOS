
import Foundation
import SocketIO
import KhenshinSecureMessage
import KhenshinProtocol
import LocalAuthentication

@available(iOS 13.0, *)
public class KhipuSocketIOClient {
    private var socketManager: SocketManager?
    private var socket: SocketIOClient?
    private let secureMessage: SecureMessage
    private let KHENSHIN_PUBLIC_KEY: String
    private var receivedMessages: [String]
    private var viewModel: KhipuViewModel
    private var skipExitPage: Bool
    private var showFooter: Bool
    
    public init(serverUrl url: String, browserId: String, publicKey: String, appName: String, appVersion: String, locale: String, skipExitPage: Bool, showFooter: Bool, viewModel: KhipuViewModel) {
        self.KHENSHIN_PUBLIC_KEY = publicKey
        self.secureMessage = SecureMessage.init(publicKeyBase64: nil, privateKeyBase64: nil)
        socketManager = SocketManager(socketURL: URL(string: url)!, config: [
            //.log(true),
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
        self.receivedMessages = []
        self.socket = socketManager?.defaultSocket
        self.viewModel = viewModel
        self.skipExitPage = skipExitPage
        self.showFooter = showFooter
        self.clearKhssCookies()
        self.addListeners()
        self.addParametersUiState()
    }
    
    private func addParametersUiState(){
        self.viewModel.uiState.showFooter=self.showFooter
    }
    
    private func addListeners() {
        self.socket?.on(clientEvent: .connect) { data, ack in
            print("[id: \(self.viewModel.uiState.operationId)] connected")
        }
        
        self.socket?.on(clientEvent: .disconnect) { data, ack in
            let reason = data.first as! String
            print("[id: \(self.viewModel.uiState.operationId)] disconnected, reason \(reason)")
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
                self.viewModel.disconnectClient()
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
        print("SENDING MESSAGE \(type)")
        let encryptedMessage = self.secureMessage.encrypt(plainText: message, receiverPublicKeyBase64: self.KHENSHIN_PUBLIC_KEY)
        socket?.emit(type, encryptedMessage!)
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
        }).count == 2
    }
}
