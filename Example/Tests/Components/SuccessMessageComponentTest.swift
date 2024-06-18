import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS
import KhenshinProtocol

@available(iOS 15.0, *)
final class SuccessMessageComponentTest: XCTestCase {
    func testSuccessMessageComponentRendersCorrectly() throws {
        let themeManager = ThemeManager()
        let viewModel = KhipuViewModel()
        let operationSuccess = OperationSuccess(
            canUpdateEmail: false,
            type: .operationSuccess,
            body: "Operation completed successfully",
            events: nil,
            exitURL: nil,
            operationID: "12345",
            resultMessage: nil,
            title: "Success"
        )
        let view = SuccessMessageComponent(operationSuccess: operationSuccess, viewModel: viewModel)
            .environmentObject(themeManager)

        let inspectView = try view.inspect().view(SuccessMessageComponent.self)
        let images = inspectView.findAll(ViewType.Image.self)
        
        XCTAssertEqual(images.count, 1)
        XCTAssertNoThrow(try inspectView.find(text: "Success"))
        XCTAssertNoThrow(try inspectView.find(text: "Operation completed successfully"))
        XCTAssertNoThrow(try inspectView.find(text: "default.operation.code.label"))
        XCTAssertNoThrow(try inspectView.find(text: "12345"))
    }
}
