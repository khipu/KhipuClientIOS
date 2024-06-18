import XCTest
@testable import KhipuClientIOS

final class FieldUpdaterTest: XCTestCase {
    func testFunctionsExists() throws {
        XCTAssertNoThrow(FieldUpdater().appendText)
        XCTAssertNoThrow(FieldUpdater().removeLastChar)
        XCTAssertNoThrow(FieldUpdater().clearText)
        XCTAssertNoThrow(FieldUpdater().setText)
    }
}
