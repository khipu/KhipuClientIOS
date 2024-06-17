
import XCTest
import SwiftUI
import ViewInspector
import KhenshinProtocol

@testable import KhipuClientIOS

@available(iOS 15.0.0, *)
final class HeaderCheckboxFieldTest: XCTestCase {

    func testHeaderCheckboxFieldView() throws {
        let viewModel = KhipuViewModel()
        let isValid: (Bool) -> Void = { param in }
        let returnValue: (String) -> Void = { param in }

        viewModel.uiState = KhipuUiState()
        viewModel.uiState.translator = KhipuTranslator(translations: [:])

        let formItem = try! FormItem(
                 """
                     {
                       "id": "item",
                       "title": "The title",
                       "label": "Some stuff",
                       "items": ["item 1", "item2", "item 3"],
                       "type": "\(FormItemTypes.headerCheckbox.rawValue)",
                       "defaultState": "on"
                     }
                 """
         )

        var view = KhipuHeaderCheckboxField(
            formItem: formItem,
            hasNextField: false,
            isValid:  isValid,
            returnValue: returnValue,
            viewModel: viewModel
        )

        let inspected = try view.environmentObject(ThemeManager()).inspect()

        let title = try inspected.find(viewWithAccessibilityIdentifier: "titleText").text().string()
        XCTAssertEqual(title, "The title")

        let label = try inspected.find(viewWithAccessibilityIdentifier: "labelText")
        let labelText = try label.text().string()
        XCTAssertEqual(labelText, "Some stuff")

       // let items = try view.inspect().find(viewWithAccessibilityIdentifier: "items")

        let expectation = view.on(\.didAppear) { view in
            let toggle = try view
                .vStack()
                .hStack(1)
                .toggle(0)
            XCTAssertTrue(try toggle.isOn())
        }

        ViewHosting.host(view: view.environmentObject(ThemeManager()))

        wait(for: [expectation], timeout: 0.1)
    }
}
