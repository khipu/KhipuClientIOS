import XCTest
import SwiftUI
import ViewInspector
import KhenshinProtocol

@testable import KhipuClientIOS

@available(iOS 15.0.0, *)
final class SimpleTextFieldTest: XCTestCase {
    
    let viewModel = KhipuViewModel()
    let isValid: (Bool) -> Void = { param in }
    let returnValue: (String) -> Void = { param in }
    
    func testAsTextField() throws {
        viewModel.uiState = KhipuUiState()
        viewModel.uiState.translator = KhipuTranslator(translations: [:])
        
        let formItem = try! FormItem(
                 """
                     {
                       "id": "item",
                       "label": "Some stuff",
                       "type": "\(FormItemTypes.text.rawValue)",
                       "hint": "Some instructions"
                     }
                 """
        )
        
        let view = SimpleTextField(
            formItem: formItem,
            hasNextField: false,
            isValid:  isValid,
            returnValue: returnValue,
            viewModel: viewModel
        )
        
        let inspected = try view.environmentObject(ThemeManager()).inspect()
        
        let label = try inspected.find(viewWithAccessibilityIdentifier: "labelText").text().string()
        XCTAssertEqual(label, "Some stuff")
     
        let hint = try inspected.find(viewWithAccessibilityIdentifier: "hintText").text().string()
        XCTAssertEqual(hint, "Some instructions")
        
    }
    
    func testAsTextSecure() throws {
        viewModel.uiState = KhipuUiState()
        viewModel.uiState.translator = KhipuTranslator(translations: [:])
        
        let formItem = try! FormItem(
                 """
                     {
                       "id": "item",
                       "label": "Some stuff",
                       "type": "\(FormItemTypes.text.rawValue)",
                       "hint": "Some instructions",
                       "secure": true,
                     }
                 """
        )
        
        let view = SimpleTextField(
            formItem: formItem,
            hasNextField: false,
            isValid:  isValid,
            returnValue: returnValue,
            viewModel: viewModel
        )
        
        let inspected = try view.environmentObject(ThemeManager()).inspect()
        
        let label = try inspected.find(viewWithAccessibilityIdentifier: "labelText").text().string()
        XCTAssertEqual(label, "Some stuff")
        
        let hint = try inspected.find(viewWithAccessibilityIdentifier: "hintText").text().string()
        XCTAssertEqual(hint, "Some instructions")
    }
}
