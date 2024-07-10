import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS
@testable import KhenshinProtocol

@available(iOS 15.0, *)
final class RedirectToManualComponentTest: XCTestCase {

    func testRedirectoToManualComponentRendersCorrectly() throws {
        let themeManager = ThemeManager()
        let viewModel = KhipuViewModel()
        let operationFailure = OperationFailure(
            type: .operationFailure,
            body: "The operation could not be completed",
            events: nil,
            exitURL: nil,
            operationID: "12345",
            resultMessage: nil,
            title: "Operation Failed",
            reason: .bankWithoutAutomaton
        )
        
        let view = RedirectToManualComponent(operationFailure: operationFailure, viewModel: viewModel)
            .environmentObject(themeManager)
        
        let inspectedView = try view.inspect().view(RedirectToManualComponent.self)
        
        XCTAssertNotNil(try? inspectedView.find(text: "page.redirectManual.redirecting"), "Failed to find the text:page.redirectManual.redirecting")

    }

}
