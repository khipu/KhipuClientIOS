import Foundation

public class KhipuTranslator {
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
