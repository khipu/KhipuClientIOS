import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class FormInfoTests: XCTestCase {

    func testFormInfoView() throws {
        let themeManager = ThemeManager()
        let view = FormInfo(text: "Information")
            .environmentObject(themeManager)
        
        ViewHosting.host(view: view)
        
        let inspectedView = try view.inspect()
        
        let hStack = try inspectedView.hStack()
        XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(hStack, expectedText: "Information"), "Failed to find the text: Information")
    }
}
