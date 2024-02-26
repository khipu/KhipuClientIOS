//
//  KhenshinClient.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 19-02-24.
//

import Foundation
import SocketIO
import KhenshinSecureMessage
import KhenshinProtocol
import RxSwift

public class KhenshinClient {
    private let socketManager: SocketManager
    private let socket: SocketIOClient
    private let secureMessage: SecureMessage
    private let KHENSHIN_PUBLIC_KEY: String
    private var operationId: String
    private var receivedMessages: [String]
    private var formMocks: FormMocks
    
    public init(serverUrl url: String, publicKey: String, operationId: String) {
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
        self.operationId = operationId
        self.receivedMessages = []
        self.socket = socketManager.defaultSocket
        self.formMocks = FormMocks()
        
    }
    
    public func setupSocketEvents() -> Observable<[String]> {
        return Observable.create { observer in
            self.socket.on(clientEvent: .connect) { data, ack in
                print("[id: \(self.operationId)] connected")
            }
            
            self.socket.on(clientEvent: .reconnect) { data, ack in
                print("[id: \(self.operationId)] reconnect")
            }
            
            self.socket.on(clientEvent: .reconnectAttempt) { data, ack in
                print("[id: \(self.operationId)] reconnect attempt \(data.first!)")
            }
            
            self.socket.on(clientEvent: .error) { data, ack in
                print("[id: \(self.operationId)] error \(data.first!)")
            }
            
            self.socket.on(clientEvent: .disconnect) { data, ack in
                let reason = data.first as! String
                print("[id: \(self.operationId)] disconnected, reason \(reason)")
            }
            
            self.socket.on(MessageType.operationRequest.rawValue) { data, ack in
                if (self.isRepeatedMessage(data: data, type: MessageType.operationRequest.rawValue)) {
                    return
                }
                if ((data.first as? String) != nil) {
                    self.sendOperationResponse()
                }
<<<<<<< HEAD
            }
            
            self.socket.on(MessageType.translation.rawValue) { data, ack in
                if (self.isRepeatedMessage(data: data, type: MessageType.translation.rawValue)) {
                    return
                }
                let encryptedData = data.first as! String
                let mid = data[1] as! String
                let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
                observer.onNext([MessageType.translation.rawValue, decryptedMessage!])
                do {
                    let translations = try Translations(decryptedMessage!)
                } catch {
                    print("Error processing form message, mid \(mid)")
                }
=======
            } catch {
                print("Error processing form message, mid \(mid)")
            }
        }

        socket.on(MessageType.siteInfo.rawValue) { data, ack in
            if (self.isRepeatedMessage(data: data, type: MessageType.siteInfo.rawValue)) {
                return
            }
            let encryptedData = data.first as! String
            let mid = data[1] as! String
            let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
            do {
                let formRequest = try SiteInfo(decryptedMessage!)
            } catch {
                print("Error processing form message, mid \(mid)")
            }
        }

        socket.on(MessageType.operationSuccess.rawValue) { data, ack in
            if (self.isRepeatedMessage(data: data, type: MessageType.operationSuccess.rawValue)) {
                return
            }
            let encryptedData = data.first as! String
            let mid = data[1] as! String
            let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
            do {
                let formRequest = try OperationSuccess(decryptedMessage!)
                    if let jsonData = decryptedMessage?.data(using: .utf8) {
                        do {
                            let decoder = JSONDecoder()
                            let operationSuccess = try decoder.decode(OperationSuccess.self, from: jsonData)

                            self.khenshinView.drawOperationSuccessComponent(operationSuccess: operationSuccess)
                        } catch {
                            print("Error al decodificar JSON: \(error)")
                        }
                    } else {
                        print("Error al convertir cadena a datos.")
                    }

            } catch {
                print("Error processing form message, mid \(mid)")
            }
        }

        socket.on(MessageType.operationWarning.rawValue) { data, ack in
            if (self.isRepeatedMessage(data: data, type: MessageType.operationWarning.rawValue)) {
                return
            }
            let encryptedData = data.first as! String
            let mid = data[1] as! String
            let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
            do {
                let formRequest = try OperationWarning(decryptedMessage!)
                if let jsonData = decryptedMessage?.data(using: .utf8) {
                    do {
                        let decoder = JSONDecoder()
                        let operationWarning = try decoder.decode(OperationWarning.self, from: jsonData)

                        self.khenshinView.drawOperationWarningComponent(operationWarning: operationWarning)
                    } catch {
                        print("Error al decodificar JSON: \(error)")
                    }
                } else {
                    print("Error al convertir cadena a datos.")
                }
            } catch {
                print("Error processing form message, mid \(mid)")
>>>>>>> ea8c9f4 (add files from test)
            }
            
            self.socket.on(MessageType.formRequest.rawValue) { data, ack in
                
                if (self.isRepeatedMessage(data: data, type: MessageType.formRequest.rawValue)) {
                    return
                }
                let encryptedData = data.first as! String
                let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
                observer.onNext([MessageType.formRequest.rawValue, decryptedMessage!])
            }
<<<<<<< HEAD
            
            self.socket.on(MessageType.progressInfo.rawValue) { data, ack in
                if (self.isRepeatedMessage(data: data, type: MessageType.progressInfo.rawValue)) {
                    return
                }
                let encryptedData = data.first as! String
                let mid = data[1] as! String
                let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
                observer.onNext([MessageType.progressInfo.rawValue, decryptedMessage!])
                do {
                    let progressInfo = try ProgressInfo(decryptedMessage!)
                } catch {
                    print("Error processing form message, mid \(mid)")
                }
=======
            let encryptedData = data.first as! String
            let mid = data[1] as! String
            let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
            do {
                let formRequest = try OperationFailure(decryptedMessage!)
                if let jsonData = decryptedMessage?.data(using: .utf8) {
                do {
                    let decoder = JSONDecoder()
                    let operationFailure = try decoder.decode(OperationFailure.self, from: jsonData)
                    self.khenshinView.drawOperationFailureComponent(operationFailure: operationFailure)
                } catch {
                    print("Error al decodificar JSON: \(error)")
                }
            } else {
                print("Error al convertir cadena a datos.")
            }
            } catch {
                print("Error processing form message, mid \(mid)")
>>>>>>> ea8c9f4 (add files from test)
            }
            
            self.socket.on(MessageType.siteInfo.rawValue) { data, ack in
                if (self.isRepeatedMessage(data: data, type: MessageType.siteInfo.rawValue)) {
                    return
                }
                let encryptedData = data.first as! String
                let mid = data[1] as! String
                let decryptedMessage = self.secureMessage.decrypt(cipherText: encryptedData, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
                observer.onNext([MessageType.siteInfo.rawValue, decryptedMessage!])
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
                observer.onNext([MessageType.operationSuccess.rawValue, decryptedMessage!])
                do {
                    let formRequest = try OperationSuccess(decryptedMessage!)
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
                observer.onNext([MessageType.operationWarning.rawValue, decryptedMessage!])
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
                observer.onNext([MessageType.operationFailure.rawValue, decryptedMessage!])
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
                observer.onNext([MessageType.operationDescriptorInfo.rawValue, decryptedMessage!])
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
                observer.onNext([MessageType.operationInfo.rawValue, decryptedMessage!])
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
                observer.onNext([MessageType.siteOperationComplete.rawValue, decryptedMessage!])
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
                observer.onNext([MessageType.preAuthorizationStarted.rawValue, decryptedMessage!])
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
                observer.onNext([MessageType.preAuthorizationCanceled.rawValue, decryptedMessage!])
                do {
                    let formRequest = try PreAuthorizationCanceled(decryptedMessage!)
                } catch {
                    print("Error processing form message, mid \(mid)")
                }
            }
            
            return Disposables.create {
                self.socket.disconnect()
            }
        }
    }

    public func connect() {
        socket.connect()
    }

    func isRepeatedMessage(data: [Any], type: String) -> Bool {
        if let mid = data[1] as? String {
            print("[id: \(self.operationId)] Received message \(type), mid \(mid)")
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
        if (self.operationId.count > 12){
            let operationResponse = OperationResponse(
                fingerprint: nil,
                operationDescriptor: self.operationId,
                operationID: nil,
                sessionCookie: nil,
                type: MessageType.operationResponse
            )
            self.sendMessage(type: operationResponse.type.rawValue as String, message: operationResponse)
        } else {
            let operationResponse = OperationResponse(
                fingerprint: nil,
                operationDescriptor: nil,
                operationID: self.operationId,
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
