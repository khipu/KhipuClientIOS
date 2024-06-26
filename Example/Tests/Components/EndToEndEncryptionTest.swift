import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class EndToEndEncryptionTests: XCTestCase {

    func testFormInfoView() throws {
        let themeManager = ThemeManager()
        let viewModel = KhipuViewModel()
        let message = "Encriptado"
        viewModel.uiState.translator = KhipuTranslator(translations: ["default.end.to.end.encryption": message])
        let view = EndToEndEncryption(viewModel: viewModel)
            .environmentObject(themeManager)
        
        let inspectedView = try view.inspect()
        XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(inspectedView, expectedText: message), "Failed to find the text: \(message)")
    }
}
