import XCTest
import SwiftUI
import ViewInspector
import KhenshinProtocol
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class HeaderComponentTest: XCTestCase {
    
    func testHeaderComponentRendersCorrectly() throws {
        let themeManager = ThemeManager()
        let viewModel = KhipuViewModel()
        viewModel.uiState.translator = KhipuTranslator(translations: [
            "header.amount": "MONTO A PAGAR",
            "header.code.label": "Código",
            "header.details.show": "Ver detalle",
        ])
        let operationInfo = OperationInfo(
            acceptManualTransfer: true,
            amount: "1000",
            body: "Transaction Body",
            email: "example@example.com",
            merchant: Merchant(logo: "merchant_logo", name: "Merchant Name"),
            operationID: "12345",
            subject: "Transaction Subject",
            type: .operationInfo,
            urls: Urls(
                attachment: ["https://example.com/attachment"],
                cancel: "https://example.com/cancel",
                changePaymentMethod: "https://example.com/changePaymentMethod",
                fallback: "https://example.com/fallback",
                image: "https://example.com/image",
                info: "https://example.com/info",
                manualTransfer: "https://example.com/manualTransfer",
                urlsReturn: "https://example.com/return"
            ),
            welcomeScreen: WelcomeScreen(enabled: true, ttl: 3600)
        )
        
        viewModel.uiState.operationInfo = operationInfo
        
        let view = HeaderComponent(viewModel: viewModel)
            .environmentObject(themeManager)

        let inspectedView = try view.inspect().view(HeaderComponent.self)
        let vStack = try inspectedView.vStack()
        
        XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(vStack, expectedText: "Merchant Name"), "Failed to find the text: Merchant Name")
        XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(vStack, expectedText: "Transaction Subject"), "Failed to find the text: Transaction Subject")
        XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(vStack, expectedText: "MONTO A PAGAR"), "Failed to find the text: MONTO A PAGAR")
        XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(vStack, expectedText: "1000"), "Failed to find the text: 1000")
        XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(vStack, expectedText: "CÓDIGO • 12345"), "Failed to find the text: Código • 12345")
        XCTAssertTrue(try ViewInspectorUtils.verifyButtonInStack(vStack, expectedButtonText: "Ver detalle"), "Failed to find the button with text: Ver detalle")

    }
}
