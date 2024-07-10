import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS
@testable import KhenshinProtocol

@available(iOS 15.0, *)
final class FailureMessageComponentTest: XCTestCase {

    func testFailureMessageComponentRendersCorrectly() throws {
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
            reason: .noBackendAvailable
        )
        
        let view = FailureMessageComponent(operationFailure: operationFailure, viewModel: viewModel)
            .environmentObject(themeManager)
        
        let inspectedView = try view.inspect().view(FailureMessageComponent.self)
        XCTAssertNotNil(try? inspectedView.find(text: "Operation Failed"), "Failed to find the text: Operation Failed")

    }
}
