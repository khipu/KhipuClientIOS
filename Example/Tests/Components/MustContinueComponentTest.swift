import XCTest
import SwiftUI
import ViewInspector
import KhenshinProtocol
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class MustContinueComponentTest: XCTestCase {
    
    func testMustContinueComponentRendersCorrectly() throws {
        let themeManager = ThemeManager()
        let viewModel = KhipuViewModel()
        
        let urls = Urls(
            attachment: ["https://www.khipu.com"],
            cancel: "https://www.khipu.com",
            changePaymentMethod: "https://www.khipu.com",
            fallback: "https://www.khipu.com",
            image: "https://www.khipu.com",
            info: "https://www.khipu.com",
            manualTransfer: "https://www.khipu.com",
            urlsReturn: "https://www.khipu.com"
        )
        let uiState = KhipuUiState(operationInfo: OperationInfo(
                acceptManualTransfer: true,
                amount: "$ 1.000",
                body: "body",
                email: "khipu@khipu.com",
                merchant: nil,
                operationID: "operationID",
                subject: "Subject",
                type: MessageType.operationInfo,
                urls: urls,
                welcomeScreen: nil
            )
        )
        let operationMustContinue = OperationMustContinue(
            type: MessageType.operationMustContinue,
            body: "body",
            events: nil,
            exitURL: "exitUrl",
            operationID: "operationID",
            resultMessage: "resultMessage",
            title: "Title",
            reason: nil
        )
        
        viewModel.uiState = uiState
        
        viewModel.uiState.translator = KhipuTranslator(translations: [
            "page.operationFailure.header.text.operation.task.finished": "Pago en verificación",
            "default.end.and.go.back": "Finalizar y volver",
        ])
        
        let view = MustContinueComponent(viewModel: viewModel, operationMustContinue: operationMustContinue)
            .environmentObject(themeManager)
        
        let inspectedView = try view.inspect().view(MustContinueComponent.self)
        
        XCTAssertNotNil(try? inspectedView.find(text: "Pago en verificación"), "Failed to find the text: Pago en verificación")
        XCTAssertNoThrow(try inspectedView.find(MainButton.self))
    }
    
    func testInformationSectionRendersCorrectly() throws {
        let themeManager = ThemeManager()
        let viewModel = KhipuViewModel()
        let urls = Urls(
            attachment: ["https://www.khipu.com"],
            cancel: "https://www.khipu.com",
            changePaymentMethod: "https://www.khipu.com",
            fallback: "https://www.khipu.com",
            image: "https://www.khipu.com",
            info: "https://www.khipu.com",
            manualTransfer: "https://www.khipu.com",
            urlsReturn: "https://www.khipu.com"
        )
        let uiState = KhipuUiState(translator: KhipuTranslator(translations: [
                "page.operationMustContinue.share.description": "Comparte el siguiente enlace con los firmantes para completar el pago.",
                "page.operationMustContinue.share.link.body": "Tienes un pago pendiente"
            ]), operationInfo: OperationInfo(
                acceptManualTransfer: true,
                amount: "$ 1.000",
                body: "body",
                email: "khipu@khipu.com",
                merchant: nil,
                operationID: "operationID",
                subject: "Subject",
                type: MessageType.operationInfo,
                urls: urls,
                welcomeScreen: nil
            )
        )
        let operationMustContinue = OperationMustContinue(
            type: MessageType.operationMustContinue,
            body: "body",
            events: nil,
            exitURL: "exitUrl",
            operationID: "operationID",
            resultMessage: "resultMessage",
            title: "Title",
            reason: nil
        )
        
        let view = InformationSection(operationMustContinue: operationMustContinue, khipuViewModel: viewModel, khipuUiState: uiState)
            .environmentObject(themeManager)
        
        let inspectedView = try view.inspect().view(InformationSection.self)
        let shareText = "Comparte el siguiente enlace con los firmantes para completar el pago."
        XCTAssertNotNil(try? inspectedView.find(text: shareText), "Failed to find the text:"+shareText)

        XCTAssertNoThrow(try inspectedView.find(CopyToClipboardLink.self))
    }
    
}
