//
//  KhenshinTranslator.swift
//  APNGKit
//
//  Created by Mauricio Castillo on 08-05-24.
//

import Foundation

public class KhenshinTranslator {
    private let translations: [String: String]
    
    public init(translations: [String: String]) {
        self.translations = translations
    }
    
    public func t(_ key: String, default: String? = nil) -> String {
        if let translation = translations[key] {
            return translation
        }
        return `default` ?? key
    }
}
