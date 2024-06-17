import XCTest
import SwiftUI
import ViewInspector
import KhenshinProtocol

@testable import KhipuClientIOS

@available(iOS 15.0.0, *)
final class ListFieldTest: XCTestCase {

    func testListFieldView() throws {
        let viewModel = KhipuViewModel()
        let isValid: (Bool) -> Void = { param in }
        let submitFunction: () -> Void = {}
        let returnValue: (String) -> Void = { param in }

        viewModel.uiState = KhipuUiState()
        viewModel.uiState.translator = KhipuTranslator(translations: [:])

        let formItem = try! FormItem(
             """
               {
                "id": "item1",
                "label": "item1",
                "placeholder": "placeholder",
                "type": "\(FormItemTypes.dataTable.rawValue)",
                "options":[
                        {"image": "https://s3.amazonaws.com/static.khipu.com/logos/bancos/chile/demobank-icon.png", "name": "Option 0", "value": "0" },
                        {"image": "https://s3.amazonaws.com/static.khipu.com/logos/bancos/chile/demobank-icon.png", "name": "Option 1", "value": "1" },
                        {"image": "https://s3.amazonaws.com/static.khipu.com/logos/bancos/chile/demobank-icon.png", "name": "Option 2", "value": "2", "dataTable": {"rows":[{"cells":[{"text":"Cell 1"}]}], "rowSeparator":{}}}
                ]
                }
               
             """
        )

        var view = KhipuListField(
            formItem: formItem,
            isValid:  isValid,
            returnValue: returnValue,
            submitFunction: submitFunction
        )
        let inspected = try view.environmentObject(ThemeManager()).inspect()
        
        for index in 0..<3 {
            let item = try inspected.find(viewWithAccessibilityIdentifier: "listItem\(index + 1)")
            XCTAssertEqual(try item.vStack().text(0).string(), "Option \(index)")
        }
        
        let item = try inspected.find(viewWithAccessibilityIdentifier: "listItem3")
        XCTAssertNoThrow(try item.find(viewWithAccessibilityIdentifier: "dataTable"))
    }
}
