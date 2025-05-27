import XCTest
import SwiftUI
import ViewInspector
import KhenshinProtocol

@testable import KhipuClientIOS

@available(iOS 15.0.0, *)
final class RutFieldTest: XCTestCase {
    
    let viewModel = KhipuViewModel()
    let isValid: (Bool) -> Void = { param in }
    let returnValue: (String) -> Void = { param in }
    
    func testRutField() throws {
        viewModel.uiState = KhipuUiState()
        viewModel.uiState.translator = KhipuTranslator(translations: [:])
        
        let formItem = try! FormItem(
                 """
                     {
                       "id": "item",
                       "label": "Some stuff",
                       "type": "\(FormItemTypes.rut.rawValue)",
                       "hint": "Some instructions",
                       "secure": true,
                     }
                 """
        )
        
        let view = RutField(
            formItem: formItem,
            hasNextField: false,
            isValid:  isValid,
            returnValue: returnValue,
            viewModel: viewModel
        )
        
        let inspected = try view.environmentObject(ThemeManager()).inspect()
        
        let label = try inspected.find(viewWithAccessibilityIdentifier: "labelText").text().string()
        XCTAssertEqual(label, "Some stuff")
     
        XCTAssertNoThrow(try inspected
            .vStack()
            .textField(1))
        
        let hint = try inspected.find(viewWithAccessibilityIdentifier: "hintText").text().string()
        XCTAssertEqual(hint, "Some instructions")
    }
}
