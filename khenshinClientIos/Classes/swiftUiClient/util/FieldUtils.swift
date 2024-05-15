import KhenshinProtocol

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
    
    static func getMaxDataTableCells(_ dataTable: DataTable) -> Int {
        if (dataTable.rows.isEmpty) {
            return 0
        }
        if (dataTable.rows.filter { $0.cells.isEmpty }.isEmpty) {
            return 0
        }
        return dataTable.rows.reduce(0) {max($0, $1.cells.count)}
    }

}
