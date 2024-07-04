import XCTest
import SwiftUI
import ViewInspector
import KhenshinProtocol

@testable import KhipuClientIOS

@available(iOS 15.0.0, *)
final class CheckboxFieldTest: XCTestCase {

    func testCheckboxFieldView() throws {
        let viewModel = KhipuViewModel()
        let isValid: (Bool) -> Void = { param in }
        let returnValue: (String) -> Void = { param in }
        
        viewModel.uiState = KhipuUiState()
        viewModel.uiState.translator = KhipuTranslator(translations: [:])
        
        let formItem = try! FormItem(
                     """
                         {
                           "id": "item1",
                           "label": "item1",
                           "type": "\(FormItemTypes.checkbox.rawValue)",
                           "defaultState": "off",
                           "requiredState": "on"
                         }
                     """
        )
        
        let view = CheckboxField(
            formItem: formItem,
            hasNextField: false,
            isValid: isValid,
            returnValue: returnValue,
            viewModel: viewModel
        )
        let inspected = try view.environmentObject(ThemeManager()).inspect()
        
        let checkbox = try inspected.find(viewWithAccessibilityIdentifier: "checkbox").toggle()
        XCTAssertFalse(try checkbox.isOn())
        
    }
}
