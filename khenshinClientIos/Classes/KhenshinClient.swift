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
    private let KHENSHIN_PUBLIC_KEY: String = "w5tIW3Ic0JMlnYz2Ztu1giUIyhv+T4CZJuKKMrbSEF8="
    
    public init(serverUrl url: String) {
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
        socket = socketManager.defaultSocket
        setupSocketEvents()
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
            }
        }
        // Agrega más eventos según sea necesario
    }
    public func connect() {
        socket.connect()
    }
    func disconnect() {
        socket.disconnect()
    }
    func sendMessage(_ message: String) {
        socket.emit("tu_evento_personalizado", message)
    }
}
