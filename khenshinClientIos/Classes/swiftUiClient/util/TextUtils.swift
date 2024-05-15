//
//  TextUtils.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 15-05-24.
//

import Foundation

func formatOperationId(_ operationId: String?) -> String {
    if operationId?.isEmpty ?? true {
        return "-"
    }
    
    if operationId?.count != 12 {
        return operationId ?? ""
    }
    
    let start = operationId?.index(operationId!.startIndex, offsetBy: 4)
    let middle = operationId?.index(operationId!.startIndex, offsetBy: 8)
    let end = operationId?.index(operationId!.endIndex, offsetBy: -4)
    
    return "\(operationId?[..<start!] ?? "")-\(operationId?[start!..<middle!] ?? "")-\(operationId?[middle!..<end!] ?? "")"
}

func cleanString(_ replaceValue: String?) -> String {
    return replaceValue?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
}

