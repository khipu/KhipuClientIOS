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
    
    public init(serverUrl url: String) {
        self.secureMessage = SecureMessage.init(publicKeyBase64: nil, privateKeyBase64: nil)
        let  ca_cert = Bundle.main.path(forResource: "ca", ofType: "cert")
        let  intermediate_cert = Bundle.main.path(forResource: "intermediate", ofType: "cert")
        var certs = [SSLCert]()
        if let certificateData = try? Data(contentsOf: URL(fileURLWithPath: ca_cert!)) as Data {
            let certificate = SSLCert(data: certificateData)
            certs.append(certificate)
        }
        
        if let certificateData = try? Data(contentsOf: URL(fileURLWithPath: intermediate_cert!)) as Data {
            let certificate = SSLCert(data: certificateData)
            certs.append(certificate)
        }

        let security: SocketIO.SSLSecurity = SocketIO.SSLSecurity(certs: certs, usePublicKeys: false)
        security.security.validatedDN = false
        socketManager = SocketManager(socketURL: URL(string: url)!, config: [
            .log(true),
            .compress,
            .secure(true),
            .selfSigned(true),
            .forceWebsockets(true),
            .forceNew(true),
            .security(security),
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

extension ServerLiveDataSocket : URLSessionDelegate
{
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}
