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

    static func formatOperationId(operationId: String?) -> String {
        guard let operationId = operationId, !operationId.isEmpty else {
            return "-"
        }

        if operationId.count != 12 {
            return operationId
        }

        let firstPart = operationId.prefix(4)
        let middlePart = operationId.dropFirst(4).prefix(4)
        let lastPart = operationId.suffix(4)

        return "\(firstPart)-\(middlePart)-\(lastPart)"
    }

    static func cleanString(replaceValue: String?) -> String {
        return replaceValue?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

    static func getFailureReasonCode(reason: FailureReasonType?) -> String {
           switch reason {
           case .acquirePageError:
               return "ap"
           case .bankWithoutAutomaton:
               return "bwa"
           case .formTimeout:
               return "ft"
           case .invalidOperationID:
               return "ioi"
           case .noBackendAvailable:
               return "nba"
           case .realTimeout:
               return "rt"
           case .serverDisconnected:
               return "sd"
           case .succeededDelayedNotAllowed:
               return "sdna"
           case .taskDownloadError:
               return "tde"
           case .taskDumped:
               return "td"
           case .taskExecutionError:
               return "tee"
           case .taskFinished:
               return "tf"
           case .taskNotificationError:
               return "tne"
           case .userCanceled:
               return "uc"
           case .none:
               return ""
           }
       }
    
    static func getKeyboardType(formItem: FormItem) -> UIKeyboardType {
        if (formItem.number ?? false) {
            if (formItem.decimal ?? false) {
                return UIKeyboardType.numbersAndPunctuation
            } else {
                return UIKeyboardType.numberPad
            }
        }
        if (formItem.email ?? false) {
            return UIKeyboardType.emailAddress
        }
        return UIKeyboardType.default

    }

}
