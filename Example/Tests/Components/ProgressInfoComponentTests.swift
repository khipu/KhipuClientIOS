import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS

@available(iOS 15.0,*)
final class ProgressInfoComponentTests: XCTestCase {
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
        let exp = expectation(
            description: "onAppear"
        )
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 1
        ) {
            exp.fulfill()
            do {
                let inspectedView = try view.inspect().view(
                    ProgressInfoComponent.self
                )
                XCTAssertTrue(
                    try ViewInspectorUtils.verifyTextInStack(
                        inspectedView.vStack().vStack(
                            0
                        ),
                        expectedText: message
                    ),
                       "Failed to find the text: \( message)"
                )
            } catch {
                XCTFail(
                   "Failed to inspect view: \(error)"
                )
            }
        }
        wait(
            for: [exp],
            timeout: 2.0
        )
    }
}
