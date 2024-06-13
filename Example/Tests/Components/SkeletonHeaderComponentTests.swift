import XCTest
import ViewInspector
import SwiftUI
import KhenshinProtocol
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class SkeletonHeaderComponentTests: XCTestCase {
    func testSkeletonHeaderComponentRendersCorrectly() throws {
        let themeManager = ThemeManager()
        
        let view = SkeletonHeaderComponent().environmentObject(themeManager)
        
        ViewHosting.host(view: view)
        
        let exp = expectation(description: "onAppear")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exp.fulfill()
            do {
                let inspectView = try view.inspect().view(SkeletonHeaderComponent.self)
                let vStack = try inspectView.vStack()
                
                XCTAssertNoThrow(try vStack.hStack(0))
                XCTAssertNoThrow(try vStack.divider(1))
                XCTAssertNoThrow(try vStack.hStack(2))
                
                XCTAssertNoThrow(try vStack.hStack(0).shape(0))
                XCTAssertNoThrow(try vStack.hStack(0).vStack(1))
                XCTAssertNoThrow(try vStack.hStack(0).vStack(1).shape(0))
                XCTAssertNoThrow(try vStack.hStack(0).vStack(1).shape(1))
                XCTAssertNoThrow(try vStack.hStack(0).spacer(2))
                XCTAssertNoThrow(try vStack.hStack(0).shape(3))
                
                XCTAssertNoThrow(try vStack.hStack(2).shape(0))
                XCTAssertNoThrow(try vStack.hStack(2).spacer(1))
                XCTAssertNoThrow(try vStack.hStack(2).shape(2))
            } catch {
              XCTFail("Failed to inspect view: \(error)")
            }
        }
        wait(for: [exp], timeout: 2.0)
    }
}
