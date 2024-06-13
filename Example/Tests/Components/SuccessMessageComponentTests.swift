import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS
import KhenshinProtocol

@available(iOS 15.0, *)
final class SuccessMessageComponentTests: XCTestCase {
    func testSuccessMessageComponentRendersCorrectly() throws {
        let themeManager = ThemeManager()
        let viewModel = MockKhipuViewModel()
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
        ViewHosting.host(view: view)
        let exp = expectation(description: "onAppear")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exp.fulfill()
            do {
                let inspectedView = try view.inspect().view(SuccessMessageComponent.self)
                let imageView = try inspectedView.vStack().group(0).image(0)
                XCTAssertEqual(try imageView.foregroundColor(), themeManager.selectedTheme.colors.success, "Image foreground color is incorrect")
                XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(inspectedView.vStack().group(0), expectedText: "Success"), "Failed to find the title: Success")
                XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(inspectedView.vStack().group(1), expectedText: "Operation completed successfully"), "Failed to find the body text: Operation completed successfully")
                XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(inspectedView.vStack().group(1), expectedText: viewModel.uiState.translator.t("default.operation.code.label")), "Failed to find the operation code label")
                XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(inspectedView.vStack().group(2), expectedText: "12345"), "Failed to find the operation ID: 12345")
            } catch {
                XCTFail("Failed to inspect view: \(error)")
            }
        }
        wait(for: [exp], timeout: 2.0)
    }
}
