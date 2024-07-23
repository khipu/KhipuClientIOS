import XCTest
import KhenshinProtocol
@testable import KhipuClientIOS

final class FieldUtilsTest: XCTestCase {
    
    func testIsEmpty() throws {
        XCTAssertTrue(FieldUtils.isEmpty(""))
        XCTAssertTrue(FieldUtils.isEmpty(" "))
        XCTAssertTrue(FieldUtils.isEmpty("  "))
        XCTAssertFalse(FieldUtils.isEmpty("a"))
        XCTAssertFalse(FieldUtils.isEmpty("  b"))
        XCTAssertFalse(FieldUtils.isEmpty("c  "))
        XCTAssertFalse(FieldUtils.isEmpty(" d "))
    }
    
    func testMatches() throws {
        XCTAssertTrue(FieldUtils.matches("Test", regex: "Test"))
        XCTAssertTrue(FieldUtils.matches("Test", regex: "([A-Z])\\w+"))
        XCTAssertTrue(FieldUtils.matches("9999", regex: "([0-9])\\w+"))
        XCTAssertFalse(FieldUtils.matches("Test", regex: "Untest"))
        XCTAssertFalse(FieldUtils.matches("9999", regex: "([A-Z])\\w+"))
        XCTAssertFalse(FieldUtils.matches("Test", regex: "([0-9])\\w+"))
    }
    
    func testMaxDataTableCells() throws {
        let dataTable1 = try DataTable(
        """
            {
                "rows":[
                    {"cells":[
                        {"text":"Cell 1"},
                        {"text":"Cell 2"},
                        {"text":"Cell 3"}
                    ]},
                    {"cells":[
                        {"text":"Cell 1"},
                        {"text":"Cell 2"}
                    ]}
                ], "rowSeparator":{}
            }
        """)
        let dataTable2 = try DataTable(
        """
            {
                "rows":[
                    {"cells":[
                        {"text":"Cell 1"}
                    ]}
                ], "rowSeparator":{}
            }
        """)
        let dataTable3 = try DataTable(
        """
            {
                "rows":[], "rowSeparator":{}
            }
        """)
        
        XCTAssertEqual(FieldUtils.getMaxDataTableCells(dataTable1), 3)
        XCTAssertEqual(FieldUtils.getMaxDataTableCells(dataTable2), 1)
        XCTAssertEqual(FieldUtils.getMaxDataTableCells(dataTable3), 0)
    }
    func testFormatOperationId() throws {
        XCTAssertEqual(FieldUtils.formatOperationId(operationId: "abcdefghijkl"), "abcd-efgh-ijkl")
        XCTAssertEqual(FieldUtils.formatOperationId(operationId: "abcde"), "abcde")
        XCTAssertEqual(FieldUtils.formatOperationId(operationId: ""), "-")
    }
    
    func testCleanString() throws {
        XCTAssertEqual(FieldUtils.cleanString(replaceValue: " clean string"), "clean string")
        XCTAssertEqual(FieldUtils.cleanString(replaceValue: " clean string    "), "clean string")
        XCTAssertEqual(FieldUtils.cleanString(replaceValue: "clean string    "), "clean string")
    }
    
    func testGetFailureReasonCode() {
        XCTAssertEqual(FieldUtils.getFailureReasonCode(reason: .acquirePageError), "-ap")
        XCTAssertEqual(FieldUtils.getFailureReasonCode(reason: .bankWithoutAutomaton), "-bwa")
        XCTAssertEqual(FieldUtils.getFailureReasonCode(reason: .formTimeout), "-ft")
        XCTAssertEqual(FieldUtils.getFailureReasonCode(reason: .invalidOperationID), "-ioi")
        XCTAssertEqual(FieldUtils.getFailureReasonCode(reason: .noBackendAvailable), "-nba")
        XCTAssertEqual(FieldUtils.getFailureReasonCode(reason: .realTimeout), "-rt")
        XCTAssertEqual(FieldUtils.getFailureReasonCode(reason: .serverDisconnected), "-sd")
        XCTAssertEqual(FieldUtils.getFailureReasonCode(reason: .succeededDelayedNotAllowed), "-sdna")
        XCTAssertEqual(FieldUtils.getFailureReasonCode(reason: .taskDownloadError), "-tde")
        XCTAssertEqual(FieldUtils.getFailureReasonCode(reason: .taskDumped), "-td")
        XCTAssertEqual(FieldUtils.getFailureReasonCode(reason: .taskExecutionError), "-tee")
        XCTAssertEqual(FieldUtils.getFailureReasonCode(reason: .taskFinished), "-tf")
        XCTAssertEqual(FieldUtils.getFailureReasonCode(reason: .taskNotificationError), "-tne")
        XCTAssertEqual(FieldUtils.getFailureReasonCode(reason: .userCanceled), "-uc")
        XCTAssertEqual(FieldUtils.getFailureReasonCode(reason: .none), "")
        XCTAssertEqual(FieldUtils.getFailureReasonCode(reason: nil), "")
    }
    
    func testGetKeyboardType() {
        let numberAndDecimal = try! FormItem(
             """
                 {
                   "id": "number",
                   "label": "Number",
                   "type": "\(FormItemTypes.text.rawValue)",
                   "hint": "Enter some number",
                   "number": true,
                   "decimal": true,
                   "placeHolder": "Ej: 9"
                 }
             """
        )
        
        XCTAssertEqual(FieldUtils.getKeyboardType(formItem: numberAndDecimal), UIKeyboardType.numbersAndPunctuation)
        
        let numberOnly = try! FormItem(
             """
                 {
                   "id": "number",
                   "label": "Number",
                   "type": "\(FormItemTypes.text.rawValue)",
                   "hint": "Enter some number",
                   "number": true,
                   "placeHolder": "Ej: 9"
                 }
             """
        )
        
        XCTAssertEqual(FieldUtils.getKeyboardType(formItem: numberOnly), UIKeyboardType.numberPad)
        
        let emailOnly = try! FormItem(
             """
                 {
                   "id": "email",
                   "label": "Email",
                   "type": "\(FormItemTypes.text.rawValue)",
                   "hint": "Enter your email",
                   "email": true,
                   "placeHolder": "Ej: 9"
                 }
             """
        )
        
        XCTAssertEqual(FieldUtils.getKeyboardType(formItem: emailOnly), UIKeyboardType.emailAddress)
        
        let defaultForm = try! FormItem(
             """
                 {
                   "id": "item1",
                   "label": "Some text",
                   "type": "\(FormItemTypes.text.rawValue)",
                   "hint": "Enter some text",
                   "placeHolder": "Ej: Enter some text"
                 }
             """
        )
        
        XCTAssertEqual(FieldUtils.getKeyboardType(formItem: defaultForm), UIKeyboardType.default)
    }
    
    func testGetElement() {
        enum Enum: Int, CaseIterable {
            case first = 1
            case second = 2
            case third = 3
        }
        XCTAssertEqual(FieldUtils.getElement(Enum.self, at: 0), Enum.first)
        XCTAssertEqual(FieldUtils.getElement(Enum.self, at: 1), Enum.second)
        XCTAssertEqual(FieldUtils.getElement(Enum.self, at: 2), Enum.third)
        XCTAssertNil(FieldUtils.getElement(Enum.self, at: 3))
        XCTAssertNil(FieldUtils.getElement(Enum.self, at: -1))
    }
}
