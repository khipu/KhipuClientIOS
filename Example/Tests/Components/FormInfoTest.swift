import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class FormInfoTest: XCTestCase {

    func testFormInfoView() throws {
        let themeManager = ThemeManager()
        let view = FormInfo(text: "Information")
            .environmentObject(themeManager)
        
        let inspectedView = try view.inspect()
        XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(inspectedView, expectedText: "Information"), "Failed to find the text: Information")
    }
}
