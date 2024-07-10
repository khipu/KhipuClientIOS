import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS
@testable import KhenshinProtocol


@available(iOS 15.0, *)
final class FormWarningTest: XCTestCase {

    func testFormWarningCorrectly() throws {
        let themeManager = ThemeManager()
        let view = FormWarning(text: "Warning message")
            .environmentObject(themeManager)

        let inspectedView = try view.inspect().view(FormWarning.self)
        let hStack = try inspectedView.hStack()
        XCTAssertNotNil(try? inspectedView.find(text: "Warning message"), "Failed to find the text: Warning message")

    }

}
