import XCTest
import ViewInspector
import SwiftUI
import KhenshinProtocol
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class TimeoutMessageComponentTests: XCTestCase {
    func testTimeoutMessageComponentRendersCorrectly() throws {
        let themeManager = ThemeManager()
        let viewModel = KhipuViewModel()
        
        let operationFailure = OperationFailure(
            type: .operationFailure,
            body: "The operation could not be completed",
            events: nil,
            exitURL: nil,
            operationID: "12345",
            resultMessage: nil,
            title: "Operation Failed",
            reason: .noBackendAvailable
        )
        
        let view = TimeoutMessageComponent(operationFailure: operationFailure, viewModel: viewModel).environmentObject(themeManager)
        
        ViewHosting.host(view: view)
        
        let exp = expectation(description: "onAppear")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exp.fulfill()
            do {
                let inspectView = try view.inspect().view(TimeoutMessageComponent.self)
                let vStack = try inspectView.vStack()
                
                XCTAssertNoThrow(try vStack.group(0))
                XCTAssertEqual(try vStack.group(0).text(0).string(), "page.timeout.session.closed")
                XCTAssertNoThrow(try vStack.group(0).spacer(1))
                
                XCTAssertNoThrow(try vStack.group(1))
                XCTAssertNoThrow(try vStack.group(1).view(FormWarning.self, 0))
                XCTAssertNoThrow(try vStack.group(1).spacer(1))
                
                XCTAssertNoThrow(try vStack.group(2))
                XCTAssertNoThrow(try vStack.group(2).image(0))
                XCTAssertEqual(try vStack.group(2).text(1).string(), "page.timeout.end")
                XCTAssertNoThrow(try vStack.group(2).spacer(2))
                
                XCTAssertNoThrow(try vStack.group(3))
                XCTAssertEqual(try vStack.group(3).text(0).string(), "default.operation.code.label")
                XCTAssertNoThrow(try vStack.group(3).view(CopyToClipboardOperationId.self, 1))
                
                XCTAssertNoThrow(try vStack.find(MainButton.self))
            } catch {
              XCTFail("Failed to inspect view: \(error)")
            }
        }
        wait(for: [exp], timeout: 2.0)
    }
}
