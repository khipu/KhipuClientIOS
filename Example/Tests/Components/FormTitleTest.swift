import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class FormTitleTest: XCTestCase {

    func testFormTitleView() throws {
        let themeManager = ThemeManager()
        let view = FormPill(text: "Title")
            .environmentObject(themeManager)
        
        let inspectedView = try view.inspect()
        XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(inspectedView, expectedText: "Title"), "Failed to find the text: Title")

    }
}
