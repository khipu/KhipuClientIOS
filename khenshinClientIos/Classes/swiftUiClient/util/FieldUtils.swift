
class FieldUtils {
    
    static func isEmpty(_ string: String?) -> Bool {
        return string?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
    }
    
    static func matches(_ string: String, regex: String) -> Bool {
           do {
               let regex = try NSRegularExpression(pattern: regex)
               let range = NSRange(location: 0, length: string.utf16.count)
               let matches = regex.firstMatch(in: string, options: [], range: range)
               return matches != nil
           } catch {
               return false
           }
       }

}
