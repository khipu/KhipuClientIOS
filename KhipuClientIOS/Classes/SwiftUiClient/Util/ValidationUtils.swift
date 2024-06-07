import Foundation

class ValidationUtils {
    static let decimalNumberRegex = "^-?\\d+(\\.\\d*)?$"
    static let numberRegex = "^-?\\d+$"
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^(?!(^[.-].*|[^@]*[.-]@|.*\\.{2,}.*)|^.{254}.)([a-zA-Z0-9!#$%&'*+\\/=?^_`{|}~.-]+@)(?!-.*|.*-\\.)([a-zA-Z0-9-]{1,63}\\.)+[a-zA-Z]{2,15}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    static func isValidRut(_ rut: String) -> Bool {
        guard !rut.isEmpty else {
            return false
        }
        let lastDigit = String(rut.last!).lowercased()
        let body = rut.dropLast().filter { $0.isNumber }
        
        guard let bodyInt = Int(body), (7...9).contains(body.count) else {
            return false
        }
        
        return getVerificationDigit(rut: bodyInt) == lastDigit
    }
    
    static func validMinLength(_ value: String, minLength: Double?) -> Bool {
        return minLength == nil || minLength == 0.0 || Double(value.count) >= minLength!
    }
    
    static func validMaxLength(_ value: String, maxLength: Double?) -> Bool {
        return maxLength == nil || maxLength == 0.0 || Double(value.count) <= maxLength!
    }
    
    static func validMinValue(_ number: Double, minValue: Double?) -> Bool {
        return minValue == nil || minValue == 0.0 || number >= minValue!
    }
    
    static func validMaxValue(_ number: Double, maxValue: Double?) -> Bool {
        return maxValue == nil || maxValue == 0.0 || number <= maxValue!
    }
    
    private static func getVerificationDigit(rut: Int) -> String {
        var m = 0
        var s = 1
        var newRut = rut
        while newRut != 0 {
            s = (s + (newRut % 10) * (9 - (m % 6))) % 11
            newRut /= 10
            m += 1
        }
        return s != 0 ? "\(s - 1)" : "k"
    }
    
    static func isValidNumber(_ string: String, decimals: Bool) -> Bool {
        let regex = decimals ? decimalNumberRegex : numberRegex
        let numberPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return numberPredicate.evaluate(with: string)
    }
    
    static func validateCheckAndMandatory(_ isChecked: Bool, _ mandatory: Bool?, _ translator: KhipuTranslator) -> String {
        if (mandatory == true && !isChecked) {
            return translator.t("form.validation.error.default.required")
        }
        return ""
    }
}
