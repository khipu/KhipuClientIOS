import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class FormPillTests: XCTestCase {

    func testFormInfoView() throws {
        let themeManager = ThemeManager()
        let view = FormPill(text: "Nombre Banco")
            .environmentObject(themeManager)
        
        let inspectedView = try view.inspect()
        XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(inspectedView, expectedText: "Nombre Banco"), "Failed to find the text: Nombre Banco")


    }
}
