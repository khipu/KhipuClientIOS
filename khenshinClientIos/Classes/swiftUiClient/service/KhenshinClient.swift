
import Foundation
import SocketIO
import KhenshinSecureMessage
import KhenshinProtocol
import RxSwift

@available(iOS 13.0, *)
public class KhenshinClient {
    private let socketManager: SocketManager
    private let socket: SocketIOClient
    private let secureMessage: SecureMessage
    private let KHENSHIN_PUBLIC_KEY: String
    private var receivedMessages: [String]
    private var formMocks: FormMocks
    private var viewModel: KhenshinViewModel

    public init(serverUrl url: String, publicKey: String, viewModel: KhenshinViewModel) {
        self.KHENSHIN_PUBLIC_KEY = publicKey
        self.secureMessage = SecureMessage.init(publicKeyBase64: nil, privateKeyBase64: nil)
        socketManager = SocketManager(socketURL: URL(string: url)!, config: [
            .log(true),
            .compress,
            //.secure(true),
            //.selfSigned(true),
            .forceWebsockets(true),
            .forceNew(true),
            .connectParams([
                "clientId": UUID().uuidString,
                "clientPublicKey":secureMessage.publicKeyBase64,
                "locale":"ES",
                "userAgent":"ios",
                "uiType":"payment",
                "browserId":UUID().uuidString,
                "transports":["websocket"]
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
        
        self.socket.on(clientEvent: .reconnect) { data, ack in
            print("[id: \(self.viewModel.uiState.operationId)] reconnect")
        }
        
        self.socket.on(clientEvent: .reconnectAttempt) { data, ack in
            print("[id: \(self.viewModel.uiState.operationId)] reconnect attempt \(data.first!)")
        }
        
        self.socket.on(clientEvent: .error) { data, ack in
            print("[id: \(self.viewModel.uiState.operationId)] error \(data.first!)")
            self.viewModel.uiState.connected = false
        }
        
        self.socket.on(clientEvent: .disconnect) { data, ack in
            let reason = data.first as! String
            print("[id: \(self.viewModel.uiState.operationId)] disconnected, reason \(reason)")
            self.viewModel.uiState.connected = false
        }
        
        self.socket.on(MessageType.operationRequest.rawValue) { data, ack in
            if (self.isRepeatedMessage(data: data, type: MessageType.operationRequest.rawValue)) {
                return
            }
            self.viewModel.uiState.currentMessageType = MessageType.operationRequest.rawValue
            if ((data.first as? String) != nil) {
                self.sendOperationResponse()
            }
        }
        
        self.socket.on(MessageType.translation.rawValue) { data, ack in
            if (self.isRepeatedMessage(data: data, type: MessageType.translation.rawValue)) {
                return
            }
            let encryptedData = data.first as! String
            let mid = data[1] as! String
            let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
            
            do {
                let translations = try Translations(decryptedMessage!)
            } catch {
                print("Error processing form message, mid \(mid)")
            }
        }
        
        self.socket.on(MessageType.formRequest.rawValue) { data, ack in
            
            if (self.isRepeatedMessage(data: data, type: MessageType.formRequest.rawValue)) {
                return
            }
            let encryptedData = data.first as! String
            let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
            self.viewModel.uiState.currentMessageType = MessageType.formRequest.rawValue
        }
        
        self.socket.on(MessageType.progressInfo.rawValue) { data, ack in
            if (self.isRepeatedMessage(data: data, type: MessageType.progressInfo.rawValue)) {
                return
            }
            let encryptedData = data.first as! String
            let mid = data[1] as! String
            let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
            self.viewModel.uiState.currentMessageType = MessageType.progressInfo.rawValue
            do {
                let progressInfo = try ProgressInfo(decryptedMessage!)
            } catch {
                print("Error processing form message, mid \(mid)")
            }
        }
        
        self.socket.on(MessageType.siteInfo.rawValue) { data, ack in
            if (self.isRepeatedMessage(data: data, type: MessageType.siteInfo.rawValue)) {
                return
            }
            let encryptedData = data.first as! String
            let mid = data[1] as! String
            let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
            self.viewModel.uiState.currentMessageType = MessageType.siteInfo.rawValue
            do {
                let formRequest = try SiteInfo(decryptedMessage!)
            } catch {
                print("Error processing form message, mid \(mid)")
            }
        }
        
        self.socket.on(MessageType.operationSuccess.rawValue) { data, ack in
            if (self.isRepeatedMessage(data: data, type: MessageType.operationSuccess.rawValue)) {
                return
            }
            let encryptedData = data.first as! String
            let mid = data[1] as! String
            let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
            self.viewModel.uiState.currentMessageType = MessageType.operationSuccess.rawValue
            do {
                let formRequest = try OperationSuccess(decryptedMessage!)
                return
            } catch {
                print("Error processing form message, mid \(mid)")
            }
        }
        
        self.socket.on(MessageType.operationWarning.rawValue) { data, ack in
            if (self.isRepeatedMessage(data: data, type: MessageType.operationWarning.rawValue)) {
                return
            }
            let encryptedData = data.first as! String
            let mid = data[1] as! String
            let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
            self.viewModel.uiState.currentMessageType = MessageType.operationWarning.rawValue
            do {
                let formRequest = try OperationWarning(decryptedMessage!)
            } catch {
                print("Error processing form message, mid \(mid)")
            }
        }
        
        self.socket.on(MessageType.operationFailure.rawValue) { data, ack in
            if (self.isRepeatedMessage(data: data, type: MessageType.operationFailure.rawValue)) {
                return
            }
            let encryptedData = data.first as! String
            let mid = data[1] as! String
            let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
            print("[id: \(self.viewModel.uiState.operationId)] disconnected, reason \(String(describing: decryptedMessage))")
            self.viewModel.uiState.currentMessageType = MessageType.operationFailure.rawValue
            do {
                let formRequest = try OperationFailure(decryptedMessage!)
            } catch {
                print("Error processing form message, mid \(mid)")
            }
        }
        
        self.socket.on(MessageType.operationDescriptorInfo.rawValue) { data, ack in
            if (self.isRepeatedMessage(data: data, type: MessageType.operationDescriptorInfo.rawValue)) {
                return
            }
            let encryptedData = data.first as! String
            let mid = data[1] as! String
            let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
            self.viewModel.uiState.currentMessageType = MessageType.operationDescriptorInfo.rawValue
            do {
                let formRequest = try OperationDescriptorInfo(decryptedMessage!)
            } catch {
                print("Error processing form message, mid \(mid)")
            }
        }
        
        self.socket.on(MessageType.operationInfo.rawValue) { data, ack in
            if (self.isRepeatedMessage(data: data, type: MessageType.operationInfo.rawValue)) {
                return
            }
            let encryptedData = data.first as! String
            let mid = data[1] as! String
            let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
            self.viewModel.uiState.currentMessageType = MessageType.operationInfo.rawValue
            do {
                let formRequest = try OperationInfo(decryptedMessage!)
                
            } catch {
                print("Error processing form message, mid \(mid)")
            }
        }
        
        self.socket.on(MessageType.siteOperationComplete.rawValue) { data, ack in
            if (self.isRepeatedMessage(data: data, type: MessageType.siteOperationComplete.rawValue)) {
                return
            }
            let encryptedData = data.first as! String
            let mid = data[1] as! String
            let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
            self.viewModel.uiState.currentMessageType = MessageType.siteOperationComplete.rawValue
            do {
                let formRequest = try SiteOperationComplete(decryptedMessage!)
            } catch {
                print("Error processing form message, mid \(mid)")
            }
        }
        
        self.socket.on(MessageType.preAuthorizationStarted.rawValue) { data, ack in
            if (self.isRepeatedMessage(data: data, type: MessageType.preAuthorizationStarted.rawValue)) {
                return
            }
            let encryptedData = data.first as! String
            let mid = data[1] as! String
            let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
            self.viewModel.uiState.currentMessageType = MessageType.preAuthorizationStarted.rawValue
            do {
                let formRequest = try PreAuthorizationStarted(decryptedMessage!)
            } catch {
                print("Error processing form message, mid \(mid)")
            }
        }
        
        self.socket.on(MessageType.preAuthorizationCanceled.rawValue) { data, ack in
            if (self.isRepeatedMessage(data: data, type: MessageType.preAuthorizationCanceled.rawValue)) {
                return
            }
            let encryptedData = data.first as! String
            let mid = data[1] as! String
            let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
            self.viewModel.uiState.currentMessageType = MessageType.preAuthorizationCanceled.rawValue
            do {
                let formRequest = try PreAuthorizationCanceled(decryptedMessage!)
            } catch {
                print("Error processing form message, mid \(mid)")
            }
            

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
        if (self.viewModel.uiState.operationId.count > 12){
            let operationResponse = OperationResponse(
                fingerprint: nil,
                operationDescriptor: self.viewModel.uiState.operationId,
                operationID: nil,
                sessionCookie: nil,
                type: MessageType.operationResponse
            )
            self.sendMessage(type: operationResponse.type.rawValue as String, message: operationResponse)
        } else {
            let operationResponse = OperationResponse(
                fingerprint: nil,
                operationDescriptor: nil,
                operationID: self.viewModel.uiState.operationId,
                sessionCookie: nil,
                type: MessageType.operationResponse
            )
            self.sendMessage(type: operationResponse.type.rawValue as String, message: operationResponse)
        }

    }

    public func sendMessage(type: String, message: Encodable) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
            do {
                let jsonData = try encoder.encode(message)
                if let jsonString = String(data: jsonData, encoding: .utf8){
                    let encryptedMessage = self.secureMessage.encrypt(plainText: jsonString, receiverPublicKeyBase64: self.KHENSHIN_PUBLIC_KEY)
                    socket.emit(type, encryptedMessage!)
                }
            } catch {
                print("Error sending message")
            }
    }
}
