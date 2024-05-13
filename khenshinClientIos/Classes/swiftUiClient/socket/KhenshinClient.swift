
import Foundation
import SocketIO
import KhenshinSecureMessage
import KhenshinProtocol

@available(iOS 13.0, *)
public class KhenshinClient {
    private let socketManager: SocketManager
    private let socket: SocketIOClient
    private let secureMessage: SecureMessage
    private let KHENSHIN_PUBLIC_KEY: String
    private var receivedMessages: [String]
    private var formMocks: FormMocks
    private var viewModel: KhenshinViewModel

    public init(serverUrl url: String, publicKey: String, appName: String, appVersion: String, locale: String, viewModel: KhenshinViewModel) {
        self.KHENSHIN_PUBLIC_KEY = publicKey
        self.secureMessage = SecureMessage.init(publicKeyBase64: nil, privateKeyBase64: nil)
        socketManager = SocketManager(socketURL: URL(string: url)!, config: [
            .log(true),
            .compress,
            .forceNew(true),
            .secure(true),
            .connectParams([
                "clientId": UUID().uuidString,
                "clientPublicKey": secureMessage.publicKeyBase64,
                "locale": locale,
                "userAgent": UAString(),
                "uiType": "payment",
                "browserId": UUID().uuidString,
                "appName": appName,
                "appVersion": appVersion,
                "appOS": "iOS"
            ])
        ])
        self.receivedMessages = []
        self.socket = socketManager.defaultSocket
        self.formMocks = FormMocks()
        self.viewModel = viewModel
        self.addListeners()
        
    }
    
    private func addListeners() {
        self.socket.on(clientEvent: .connect) { data, ack in
            print("[id: \(self.viewModel.uiState.operationId)] connected")
            self.viewModel.uiState.connected = true
        }
        
        self.socket.on(clientEvent: .disconnect) { data, ack in
            let reason = data.first as! String
            print("[id: \(self.viewModel.uiState.operationId)] disconnected, reason \(reason)")
            self.viewModel.uiState.connected = false
        }
        
        self.socket.on(clientEvent: .reconnect) { data, ack in
            let reason = data.first as! String
            print("[id: \(self.viewModel.uiState.operationId)] reconnect")
        }
        
        self.socket.on(clientEvent: .reconnectAttempt) { data, ack in
            let reason = data.first as! String
            print("[id: \(self.viewModel.uiState.operationId)] reconnectAttempt")
        }
        
        
        self.socket.on(MessageType.operationRequest.rawValue) { data, ack in
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
        
        self.socket.on(MessageType.authorizationRequest.rawValue) { data, ack in
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
                print("Error processing form message, mid \(mid)")
            }
        }
        
        self.socket.on(MessageType.cancelOperationComplete.rawValue) { data, ack in
            print("Received message \(MessageType.cancelOperationComplete.rawValue)")
            if (self.isRepeatedMessage(data: data, type: MessageType.cancelOperationComplete.rawValue)) {
                return
            }
            self.viewModel.uiState.currentMessageType = MessageType.cancelOperationComplete.rawValue
        }
        
        self.socket.on(MessageType.formRequest.rawValue) { data, ack in
            print("Received message \(MessageType.formRequest.rawValue)")
            if (self.isRepeatedMessage(data: data, type: MessageType.formRequest.rawValue)) {
                return
            }
            let encryptedData = data.first as! String
            let mid = data[1] as! String
            let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
            do {
                let formRequest = try FormRequest(decryptedMessage!)
                self.viewModel.uiState.validatedFormItems = formRequest.items.reduce(into: [String: Bool]()) {
                    $0[$1.id] = false
                }
                self.viewModel.uiState.currentMessageType = MessageType.formRequest.rawValue
                self.viewModel.uiState.currentForm = formRequest
            } catch {
                print("Error processing form message, mid \(mid)")
            }
        }
        
        self.socket.on(MessageType.openAuthorizationApp.rawValue) { data, ack in
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
        
        self.socket.on(MessageType.operationDescriptorInfo.rawValue) { data, ack in
            print("Received message \(MessageType.operationDescriptorInfo.rawValue)")
            if (self.isRepeatedMessage(data: data, type: MessageType.operationDescriptorInfo.rawValue)) {
                return
            }
            self.viewModel.uiState.currentMessageType = MessageType.operationDescriptorInfo.rawValue
        }
        
        self.socket.on(MessageType.operationFailure.rawValue) { data, ack in
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
                self.viewModel.uiState.operationFinished = true
                self.disconnect()
            } catch {
                print("Error processing form message, mid \(mid)")
            }
        }
        
        self.socket.on(MessageType.operationInfo.rawValue) { data, ack in
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
        
        self.socket.on(MessageType.operationResponse.rawValue) { data, ack in
            print("Received message \(MessageType.operationResponse.rawValue)")
            if (self.isRepeatedMessage(data: data, type: MessageType.operationResponse.rawValue)) {
                return
            }
            self.viewModel.uiState.currentMessageType = MessageType.operationResponse.rawValue
        }
        
        self.socket.on(MessageType.operationSuccess.rawValue) { data, ack in
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
                self.viewModel.uiState.operationFinished = true
                self.disconnect()
            } catch {
                print("Error processing form message, mid \(mid)")
            }
        }
        
        self.socket.on(MessageType.operationWarning.rawValue) { data, ack in
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
                self.viewModel.uiState.operationFinished = true
                self.disconnect()
            } catch {
                print("Error processing form message, mid \(mid)")
            }
        }
        
        self.socket.on(MessageType.operationMustContinue.rawValue) { data, ack in
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
                self.viewModel.uiState.operationFinished = true
                self.disconnect()
            } catch {
                print("Error processing form message, mid \(mid)")
            }
        }
        
        self.socket.on(MessageType.preAuthorizationCanceled.rawValue) { data, ack in
            print("Received message \(MessageType.preAuthorizationCanceled.rawValue)")
        }
        
        self.socket.on(MessageType.preAuthorizationStarted.rawValue) { data, ack in
            print("Received message \(MessageType.preAuthorizationStarted.rawValue)")
        }
        
        self.socket.on(MessageType.progressInfo.rawValue) { data, ack in
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
                print("Error processing form message, mid \(mid)")
            }
        }
        
        self.socket.on(MessageType.translation.rawValue) { data, ack in
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
                self.viewModel.uiState.translator = KhenshinTranslator(translations: translation.data!)
            } catch {
                print("Error processing form message, mid \(mid)")
            }
        }
        
        self.socket.on(MessageType.siteInfo.rawValue) { data, ack in
            print("Received message \(MessageType.siteInfo.rawValue)")
        }
        
        self.socket.on(MessageType.siteOperationComplete.rawValue) { data, ack in
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
                print("Error processing form message, mid \(mid)")
            }
        }
        
        self.socket.on(MessageType.welcomeMessageShown.rawValue) { data, ack in
            print("Received message \(MessageType.welcomeMessageShown.rawValue)")
        }
    }

    public func connect() {
        socket.connect()
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
        socket.disconnect()
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
        print("SENDING MESSAGE \(message)")
        let encryptedMessage = self.secureMessage.encrypt(plainText: message, receiverPublicKeyBase64: self.KHENSHIN_PUBLIC_KEY)
        socket.emit(type, encryptedMessage!)
    }
}