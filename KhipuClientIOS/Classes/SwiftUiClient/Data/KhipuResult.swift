import Foundation

public struct KhipuResult: Codable {
    public let operationId: String
    public let exitTitle: String
    public let exitMessage: String
    public let result: String
    public let events: [KhipuEvent]
    public let exitUrl: String?
    public let failureReason: String?
    public let continueUrl: String?
    
    var description: String {
        return String(format: "{operationId: %@, result: %@, failureReason: %@, exitTitle: %@, exitMessage: %@, exitUrl: %@, continueUrl: %@, events: %@}", operationId, result, failureReason ?? "nil", exitTitle, exitMessage, exitUrl ?? "nil", continueUrl ?? "nil", events)
    }
    
    public func asJson() -> String {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            return String(data: data, encoding: .utf8) ?? ""
        } catch {
            return ""
        }
    }
}

public struct KhipuEvent: Codable {
    public let name: String
    public let timestamp: String
    public let type: String
    
    var description: String {
        return String(format: "{name: %@, timestamp: %@, type: %@}", name, timestamp, type)
    }
}

