import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class FormTitleTests: XCTestCase {

    func testFormTitleView() throws {
        let themeManager = ThemeManager()
        let view = FormPill(text: "Title")
            .environmentObject(themeManager)
        
        ViewHosting.host(view: view)
        
        let inspectedView = try view.inspect()
        
        let hStack = try inspectedView.hStack()
        XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(hStack, expectedText: "Title"), "Failed to find the text: Title")

    }
}
