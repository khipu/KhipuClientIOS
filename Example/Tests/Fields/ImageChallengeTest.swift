import XCTest
import SwiftUI
import ViewInspector
import KhenshinProtocol

@testable import KhipuClientIOS

@available(iOS 15.0.0, *)
final class ImageChallengeFieldTest: XCTestCase {
    
    let viewModel = KhipuViewModel()
    let isValid: (Bool) -> Void = { param in }
    let returnValue: (String) -> Void = { param in }
    
    func testImageChallengeField() throws {
        let viewModel = KhipuViewModel()
        let isValid: (Bool) -> Void = { param in }
        let returnValue: (String) -> Void = { param in }
        viewModel.uiState = KhipuUiState()
        viewModel.uiState.translator = KhipuTranslator(translations: [:])
        
        var view = ImageChallengeField(
            formItem: MockDataGenerator.createImageChallengeFormItem(label: "label", hint: "hint"),
            hasNextField: false,
            isValid:  isValid,
            returnValue: returnValue,
            viewModel: viewModel
        )
        
        let inspected = try view.environmentObject(ThemeManager()).inspect()
        
        let label = try inspected.find(viewWithAccessibilityIdentifier: "labelText").text().string()
        XCTAssertEqual(label, "label")
        
        XCTAssertNoThrow(try inspected
            .vStack()
            .vStack(1)
            .image(0)
        )
        
        let hint = try inspected.find(viewWithAccessibilityIdentifier: "hintText").text().string()
        XCTAssertEqual(hint, "hint")
        
    }
}
