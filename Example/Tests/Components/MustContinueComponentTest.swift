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
            "page.operationWarning.failure.after.notify.pre.header": "Pago en verificación",
            "default.end.and.go.back": "Finalizar y volver",
        ])
        
        let view = MustContinueComponent(viewModel: viewModel, operationMustContinue: operationMustContinue)
            .environmentObject(themeManager)
        
        let inspectedView = try view.inspect().view(MustContinueComponent.self)
        XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(inspectedView, expectedText: "Pago en verificación"), "Failed to find the text: Pago en verificación")
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
        XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(inspectedView, expectedText: shareText), "Failed to find the text: \(shareText)")
        XCTAssertNoThrow(try inspectedView.find(CopyToClipboardLink.self))
    }
    
    func testDetailItemMustContinueWithCopy() throws {
        let themeManager = ThemeManager()
        let view = DetailItemMustContinue(label: "Label", value: "Value", shouldCopyValue: true).environmentObject(themeManager)

        let inspectView = try view.inspect().view(DetailItemMustContinue.self)
        
        XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(inspectView, expectedText: "Label"), "Failed to find the text: Label one")
        XCTAssertFalse(try ViewInspectorUtils.verifyTextInStack(inspectView, expectedText: "Value"))
        XCTAssertNoThrow(try inspectView.find(CopyToClipboardOperationId.self))
    }
    
    func testDetailItemMustContinueNoCopy() throws {
        let themeManager = ThemeManager()
        let view = DetailItemMustContinue(label: "Label two", value: "Value two", shouldCopyValue: false).environmentObject(themeManager)
        
        let inspectView = try view.inspect().view(DetailItemMustContinue.self)
        
        XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(inspectView, expectedText: "Label two"), "Failed to find the text: Label two")
        XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(inspectView, expectedText: "Value two"), "Failed to find the text: Value two")
        XCTAssertThrowsError(try inspectView.find(CopyToClipboardOperationId.self))
    }
    
    func testDetailSectionRendersCorrectly() throws {
        let themeManager = ThemeManager()
        
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
        
        let view = DetailSection(operationMustContinue: operationMustContinue).environmentObject(themeManager)

        let inspectView = try view.inspect().view(DetailSection.self)
        let vStack = try inspectView.vStack()
        
        let detailItemMustContinues = inspectView.findAll(DetailItemMustContinue.self)
        let dashLines = inspectView.findAll(DashedLine.self)
        
        XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(vStack, expectedText: "default.detail.label"), "Failed to find the text: default.detail.label")
        XCTAssertEqual(detailItemMustContinues.count, 3, "Detail items not exactly 3")
        XCTAssertEqual(dashLines.count, 1, "Dashed lines not exactly 1")

    }
}
