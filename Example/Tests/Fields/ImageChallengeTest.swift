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
        
        let formItem = try! FormItem(
                 """
                     {
                       "id": "item1",
                       "label": "The great Image Challenge",
                       "placeHolder": "It is a khipu",
                       "imageData": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+P+/HgAFhAJ/wlseKgAAAABJRU5ErkJggg==",
                       "type": "\(FormItemTypes.imageChallenge.rawValue)",
                       "hint": "This is mandatory"
                     }
                 """
        )
        var view = ImageChallengeField(
            formItem: formItem,
            hasNextField: false,
            isValid:  isValid,
            returnValue: returnValue,
            viewModel: viewModel
        )
        
        let inspected = try view.environmentObject(ThemeManager()).inspect()
        
        let label = try inspected.find(viewWithAccessibilityIdentifier: "labelText").text().string()
        XCTAssertEqual(label, "The great Image Challenge")
        
        XCTAssertNoThrow(try inspected.vStack().vStack(1).image(0))
        
        let hint = try inspected.find(viewWithAccessibilityIdentifier: "hintText").text().string()
        XCTAssertEqual(hint, "This is mandatory")
        
    }
}
