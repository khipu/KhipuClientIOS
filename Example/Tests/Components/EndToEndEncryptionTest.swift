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
        viewModel.uiState.translator = KhipuTranslator(translations: ["endToEndEncryption": message])
        let view = EndToEndEncryption(viewModel: viewModel)
            .environmentObject(themeManager)
        
        ViewHosting.host(view: view)
        
        let inspectedView = try view.inspect()
        let circle = try view.inspect().view(Circle.self)
        
        let hStack = try inspectedView.hStack()
        XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(hStack, expectedText: message), "Failed to find the text: \(message)")
        XCTAssertNotNil(circle)
    }
}
