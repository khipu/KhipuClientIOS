class Validation {
    
    static func validateRut(_ rut: String) -> Bool {
        let dv = String(rut.last ?? Character(""))
        let rutBody = rut.dropLast().replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "-", with: "")
        let generatedDv = Validation.getDv(Int(rutBody) ?? 0)
        
        return rutBody.count < 10 &&
        rutBody.count > 6 &&
        generatedDv.lowercased() == dv.lowercased()
    }
    
    private static func getDv(_ T: Int) -> String {
        var M = 0
        var S = 1
        
        var T = T
        while T != 0 {
            S = (S + (T % 10) * (9 - (M % 6))) % 11
            T = T / 10
            M += 1
        }
        
        return S != 0 ? "\(S - 1)" : "k"
    }
    
    static func validateEmail(_ email: String) -> Bool {
        let emailRegex = try! NSRegularExpression(pattern: "^(?!(^[.-].*|[^@]*[.-]@|.*\\.{2,}.*)|^.{254}.)([a-zA-Z0-9!#$%&'*+\\/=?^_`{|}~.-]+@)(?!-.*|.*-\\.)([a-zA-Z0-9-]{1,63}\\.)+[a-zA-Z]{2,15}$", options: .caseInsensitive)
        let range = NSRange(location: 0, length: email.utf16.count)
        let matches = emailRegex.numberOfMatches(in: email, options: [], range: range)
        
        return matches > 0
    }
}

