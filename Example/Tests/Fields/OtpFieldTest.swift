import XCTest
import SwiftUI
import ViewInspector
import KhenshinProtocol

@testable import KhipuClientIOS

@available(iOS 15.0.0, *)
final class OtpFieldTest: XCTestCase {

    func testOtpFieldView() throws {
        let isValid: (Bool) -> Void = { param in }
        let returnValue: (String) -> Void = { param in }
        let themeManager: ThemeManager = ThemeManager()
        /*let viewModel = KhipuViewModel()
        viewModel.uiState = KhipuUiState()
        viewModel.uiState.translator = KhipuTranslator(translations: [:])*/

        let view = OtpField(
            formItem: MockDataGenerator.createOtpFormItem(id: "id", label: "label", length: 4, hint: "hint", number: false),
            isValid:  isValid,
            returnValue: returnValue
        ).environmentObject(themeManager)
        ViewHosting.host(view: view)
        let inspected = try view.inspect()
        
        //XCTAssertNotNil(try? inspected.find(text: "label"), "Failed to find the text: label")
        //XCTAssertNotNil(try? inspected.find(text: "hint"), "Failed to find the text: hint")
        /*let label = try inspected.find(viewWithAccessibilityIdentifier: "labelText")
        let text = try label.text().string()
        XCTAssertEqual(text, "label")
        
        let hint = try inspected.find(viewWithAccessibilityIdentifier: "hintText").text().string()
        XCTAssertEqual(hint, "hint")*/
        
    }
}
