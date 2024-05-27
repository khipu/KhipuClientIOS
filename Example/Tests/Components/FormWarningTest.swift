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
        
        ViewHosting.host(view: view)
        let exp = expectation(description: "onAppear")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exp.fulfill()
            do {
                let inspectedView = try view.inspect().view(FormWarning.self)
                let hStack = try inspectedView.hStack()

                XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(hStack, expectedText: "Warning message"), "Failed to find the text: Warning message")
                
                let image = try hStack.image(1)
                let imageColor = try image.foregroundColor()
                XCTAssertEqual(imageColor, themeManager.selectedTheme.colors.tertiary)

            } catch {
                XCTFail("Failed to inspect view: \(error)")
            }
        }
        
        wait(for: [exp], timeout: 2.0)
    }

}
