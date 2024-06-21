import Foundation
import KhenshinProtocol

class ValidationUtils {

    enum NumberFormatError: Error {
        case invalidNumber
    }
    
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
    
    static func validateCheckRequiredState(_ isChecked: Bool, _ requiredState: String?, _ translator: KhipuTranslator) -> String {
        if requiredState == "on" && !isChecked {
            return translator.t("form.validation.error.switch.accept.required")
        }
        
        if requiredState == "off" && isChecked {
            return translator.t("form.validation.error.switch.decline.required")
        }
        return ""
    }
    
    static func validateTextField(_ value: String, _ formItem: FormItem, _ translator: KhipuTranslator) -> String {
        if value.isEmpty {
            return translator.t("form.validation.error.default.empty")
        }
        if !ValidationUtils.validMinLength(value, minLength: formItem.minLength) {
            let minLengthString = formItem.minLength.map { String(Int($0)) } ?? "nil"
            return translator.t("form.validation.error.default.minLength.not.met").replacingOccurrences(of: "{{min}}", with: minLengthString)
        }
        if !ValidationUtils.validMaxLength(value, maxLength: formItem.maxLength) {
            let maxLengthString = formItem.maxLength.map { String(Int($0)) } ?? "nil"
            return translator.t("form.validation.error.default.maxLength.exceeded").replacingOccurrences(of: "{{max}}", with: maxLengthString)
        }
        
        if formItem.email == true && !ValidationUtils.isValidEmail(value) {
            return translator.t("form.validation.error.default.email.invalid")
        }
        
        if !FieldUtils.isEmpty(formItem.pattern) && !FieldUtils.matches(value, regex: formItem.pattern!) {
            return translator.t("form.validation.error.default.pattern.invalid")
        }
        
        if formItem.number == true {
            do {
                guard let number = Double(value) else {
                    throw NumberFormatError.invalidNumber
                }
                
                if !ValidationUtils.validMinValue(number, minValue: formItem.minValue) {
                    let minValue = formItem.minValue.map { String(Int($0)) } ?? "nil"
                    return translator.t("form.validation.error.default.minValue.not.met").replacingOccurrences(of: "{{min}}", with: minValue)
                }
                if !ValidationUtils.validMaxValue(number, maxValue: formItem.maxValue) {
                    let maxValue = formItem.maxValue.map { String(Int($0)) } ?? "nil"
                    return translator.t("form.validation.error.default.maxValue.exceeded").replacingOccurrences(of: "{{max}}", with: maxValue)
                }
            } catch {
                return translator.t("form.validation.error.default.number.invalid")
            }
        }
        return ""
    }
    
    static func validateRut(_ value: String, _ translator: KhipuTranslator) -> String {
        if value.isEmpty {
            return translator.t("form.validation.error.default.empty")
        }
        if (!ValidationUtils.isValidRut(value)){
            return translator.t("form.validation.error.rut.invalid")
        }
        return ""
    }
}
