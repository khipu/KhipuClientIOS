
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
                       "id": "item",
                       "label": "Some stuff",
                       "type": "\(FormItemTypes.checkbox.rawValue)",
                       "defaultState": "on"
                     }
                 """
         )

        var view = KhipuCheckboxField(
            formItem: formItem,
            hasNextField: false,
            isValid:  isValid,
            returnValue: returnValue,
            viewModel: viewModel
        )

        let inspected = try view.environmentObject(ThemeManager()).inspect()

        let label = try inspected.find(viewWithAccessibilityIdentifier: "labelText")
        let text = try label.text().string()
        XCTAssertEqual(text, "Some stuff")

        let expectation = view.on(\.didAppear) { view in
            let toggle = try view
                .vStack()
                .hStack(0)
                .toggle(0)
            XCTAssertTrue(try toggle.isOn())
        }

        ViewHosting.host(view: view.environmentObject(ThemeManager()))

        wait(for: [expectation], timeout: 0.1)
    }
}
