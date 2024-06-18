import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS

final class ExecuteCodeTest: XCTestCase {
    
    func testCodeExecution() throws {
        var codeExecuted = false
        
        let view = ExecuteCode {
            codeExecuted = true
        }
        _ = try view.inspect()
        
        XCTAssertTrue(codeExecuted, "The code passed to ExecuteCode should have been executed")
    }
}
