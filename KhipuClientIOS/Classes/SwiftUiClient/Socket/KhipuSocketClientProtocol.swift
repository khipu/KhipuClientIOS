import Foundation

@available(iOS 13.0, *)
public protocol KhipuSocketClientProtocol: AnyObject {
    func sendMessage(type: String, message: String)
    func connect()
    func disconnect()
    @MainActor func reconnect()
}
