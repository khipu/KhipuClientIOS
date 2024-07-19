import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS
@testable import KhenshinProtocol

@available(iOS 15.0, *)
final class DetailSectionComponentTest: XCTestCase {
/*
    
        func testDetailSectionRendersCorrectly() throws {
            let themeManager = ThemeManager()
            let viewModel = KhipuViewModel()
            viewModel.uiState.translator = KhipuTranslator(translations: [
                "default.amount.label": "Monto",
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
            
            let view = DetailSectionComponent(reason:FieldUtils.getFailureReasonCode(reason: .noBackendAvailable), operationId: "12345", operationInfo: operationInfo, viewModel: viewModel).environmentObject(themeManager)

            let inspectedView = try view.inspect().view(DetailSectionComponent.self)
            XCTAssertNotNil(try? inspectedView.find(text: "Monto"), "Failed to find the text: Monto")
        }

        func testDetailItemRendersCorrectly() throws {
            let themeManager = ThemeManager()
            let view = DetailItem(label: "Label", value: "Value")
                .environmentObject(themeManager)

            let inspectedView = try view.inspect().view(DetailItem.self)
            XCTAssertNotNil(try? inspectedView.find(text: "Label"), "Failed to find the text: Label")
            XCTAssertNotNil(try? inspectedView.find(text: "Value"), "Failed to find the text: Value")

        }
 
 */
}
