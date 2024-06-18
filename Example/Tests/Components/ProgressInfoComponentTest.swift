import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS

@available(iOS 15.0,*)
final class ProgressInfoComponentTest: XCTestCase {
    func testProgressInfoComponentRendersCorrectly() throws {
        let themeManager = ThemeManager()
        let message = "Loading message"
        let view = ProgressInfoComponent(
            message: message
        )
            .environmentObject(
                themeManager
            )
        ViewHosting.host(
            view: view
        )

        let inspectedView = try view.inspect().view(
            ProgressInfoComponent.self
        )
        XCTAssertTrue(
            try ViewInspectorUtils.verifyTextInStack(inspectedView, expectedText: message), "Failed to find the text: \( message)"
        )

    }
}
