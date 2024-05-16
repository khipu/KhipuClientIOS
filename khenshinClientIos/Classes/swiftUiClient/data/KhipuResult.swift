//
//  KhenshinResult.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 07-05-24.
//

import Foundation

public struct KhipuEvent: Codable {
    let name: String
    let timestamp: String
    let type: String
    
    var description: String {
        return String(format: "{name: %@, timestamp: %@, type: %@}", name, timestamp, type)
    }
}

public struct KhipuResult: Codable {
    let operationId: String
    let exitTitle: String
    let exitMessage: String
    let result: String
    let events: [KhipuEvent]
    let exitUrl: String
    let failureReason: String?
    let continueUrl: String?
    
    var description: String {
        return String(format: "{operationId: %@, result: %@, failureReason: %@, exitTitle: %@, exitMessage: %@, exitUrl: %@, continueUrl: %@, events: %@}", operationId, result, failureReason ?? "nil", exitTitle, exitMessage, exitUrl, continueUrl ?? "nil", events)
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

