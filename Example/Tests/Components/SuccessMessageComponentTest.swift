import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS
import KhenshinProtocol

@available(iOS 15.0, *)
final class SuccessMessageComponentTest: XCTestCase {
    /*
    func testSuccessMessageComponentRendersCorrectly() throws {
        let themeManager = ThemeManager()
        let viewModel = KhipuViewModel()
        viewModel.uiState.translator = KhipuTranslator(translations: [
            "default.amount.label": "Monto",
            "default.operation.code.label": "Código operación",
            "default.merchant.label": "Destinatario",
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



        let operationSuccess = OperationSuccess(
            canUpdateEmail: false,
            type: .operationSuccess,
            body: "Operation completed successfully",
            events: nil,
            exitURL: nil,
            operationID: "12345",
            resultMessage: nil,
            title: "Success"
        )
        let view = SuccessMessageComponent(operationSuccess: operationSuccess, viewModel: viewModel)
            .environmentObject(themeManager)

        let inspectView = try view.inspect().view(SuccessMessageComponent.self)
        let images = inspectView.findAll(ViewType.Image.self)
        
        XCTAssertEqual(images.count, 2)
        XCTAssertNoThrow(try inspectView.find(text: "Success"))
        XCTAssertNoThrow(try inspectView.find(text: "Operation completed successfully"))
        XCTAssertNoThrow(try inspectView.find(text: "12345"))
        XCTAssertNoThrow(try inspectView.find(text: "Monto"))
        XCTAssertNoThrow(try inspectView.find(text: "Código operación"))
        XCTAssertNoThrow(try inspectView.find(text: "Destinatario"))
    }
     */
}
