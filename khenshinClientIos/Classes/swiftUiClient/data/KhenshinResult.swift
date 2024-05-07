//
//  KhenshinResult.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 07-05-24.
//

import Foundation

public struct KhenshinResult: Codable {
    let operationId: String
    let exitTitle: String
    let exitMessage: String
    let exitUrl: String?
    let continueUrl: String?
    let result: String
    let failureReason: String?
    
    var description: String {
        return String(format: "{operationId: %@, result: %@, failureReason: %@, exitTitle: %@, exitMessage: %@, exitUrl: %@, continueUrl: %@}", operationId, result, failureReason ?? "nil", exitTitle, exitMessage, exitUrl ?? "nil", continueUrl ?? "nil")
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

