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

public class KhenshinClient {
    private let socketManager: SocketManager
    private let socket: SocketIOClient
    private let secureMessage: SecureMessage
    private let KHENSHIN_PUBLIC_KEY: String
    private var operationId: String
    
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
                "locale":"es-cl",
                "userAgent":"ios",
                "uiType":"payment",
                "browserId":UUID().uuidString,
                "transports":["websocket"]
            ])
        ])
        self.operationId = operationId
        self.socket = socketManager.defaultSocket
        self.setupSocketEvents()
    }
    
    private func setupSocketEvents() {
        // Configura eventos de Socket.IO aquí
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket conectado")
        }
        socket.on(MessageType.operationRequest.rawValue) { data, ack in
            if let message = data.first as? String {
                print("Mensaje recibido: \(message)")
                let desencryptedMessage = self.secureMessage.decrypt(cipherText: message, senderPublicKey: self.KHENSHIN_PUBLIC_KEY)
                print("Mensaje desencriptado: \(desencryptedMessage)")
                self.sendOperationResponse()
            }
        }
    }
    
    public func connect() {
        socket.connect()
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
    
    func sendMessage(type: String, message: Encodable) {
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
