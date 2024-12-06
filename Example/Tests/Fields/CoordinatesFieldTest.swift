import XCTest
import SwiftUI
import ViewInspector
import KhenshinProtocol

@testable import KhipuClientIOS

@available(iOS 15.0.0, *)
final class CoordinatesFieldTest: XCTestCase {
    
    func testCoordinatesFieldView() throws {
        let viewModel = KhipuViewModel()
        let isValid: (Bool) -> Void = { param in }
        let returnValue: (String) -> Void = { param in }
        
        viewModel.uiState = KhipuUiState()
        viewModel.uiState.translator = KhipuTranslator(translations: [:])
        
        let view = CoordinatesField(
            formItem: MockDataGenerator.createCoordinatesFormItem(
                id: "item1",
                labels: ["Coord 1", "Coord 2", "Coord 3"],
                hint: "Give me the answer",
                number: false
            ),
            isValid:  isValid,
            returnValue: returnValue
        )
        let inspected = try view.environmentObject(ThemeManager()).inspect()
        
        let hint = try inspected.find(viewWithAccessibilityIdentifier: "hintText").text().string()
        XCTAssertEqual(hint, "Give me the answer")
        
        
        for index in 0..<3 {
            let label = try inspected.find(viewWithAccessibilityIdentifier: "coordinateItem\(index + 1)")
            XCTAssertEqual(try label
                .vStack()
                .view(FieldLabel.self, 0)
                .anyView(0)
                .vStack(0)
                .text(0)
                .string(), "Coord \(index + 1)")
            let coordInput = try inspected.find(viewWithAccessibilityIdentifier: "coordinateInput\(index + 1)")
            XCTAssertNoThrow(try coordInput
                .implicitAnyView()
                .group()
                .textField(0))
        }
    }
}
