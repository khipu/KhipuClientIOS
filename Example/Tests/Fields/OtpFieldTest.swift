import XCTest
import SwiftUI
import ViewInspector
import KhenshinProtocol

@testable import KhipuClientIOS

@available(iOS 15.0.0, *)
final class OtpFieldTest: XCTestCase {

    func testOtpFieldView() throws {
        let viewModel = KhipuViewModel()
        let isValid: (Bool) -> Void = { param in }
        let returnValue: (String) -> Void = { param in }
        
        viewModel.uiState = KhipuUiState()
        viewModel.uiState.translator = KhipuTranslator(translations: [:])

          let formItem = try! FormItem(
                     """
                         {
                           "id": "item1",
                           "label": "Please use your OTP",
                           "length": 4,
                           "type": "\(FormItemTypes.otp.rawValue)",
                           "hint": "Give me the answer",
                            "number": false,
                         }
                     """
            )
      
        let view = OtpField(
            formItem: formItem,
            isValid:  isValid,
            returnValue: returnValue
        )
        let inspected = try view.environmentObject(ThemeManager()).inspect()
        
        let label = try inspected.find(viewWithAccessibilityIdentifier: "labelText")
        let text = try label.text().string()
        XCTAssertEqual(text, "Please use your OTP")
        
        let hint = try inspected.find(viewWithAccessibilityIdentifier: "hintText").text().string()
        XCTAssertEqual(hint, "Give me the answer")
        
        for index in 0..<4 {
            let coordInput = try inspected.find(viewWithAccessibilityIdentifier: "coordinateInput\(index + 1)")
            XCTAssertNoThrow(try coordInput
                .group()
                .textField(0))
        }
    }
}
