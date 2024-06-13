import XCTest
import SwiftUI
import ViewInspector
import KhenshinProtocol
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class MustContinueComponentTests: XCTestCase {
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
        
        ViewHosting.host(view: view)
        
        let exp = expectation(description: "onAppear")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exp.fulfill()
            do {
                let inspectedView = try view.inspect().view(MustContinueComponent.self)
                let vStack = try inspectedView.vStack()
                XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(vStack, expectedText: "Pago en verificación"), "Failed to find the text: Pago en verificación")
                XCTAssertNoThrow(try vStack.find(KhipuClientIOS.MainButton.self))
            } catch {
                XCTFail("Failed to inspect view: \(error)")
            }
        }
        wait(for: [exp], timeout: 2.0)
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
        
        ViewHosting.host(view: view)
        
        let exp = expectation(description: "onAppear")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exp.fulfill()
            do {
                let inspectedView = try view.inspect().view(InformationSection.self)
                let vStack = try inspectedView.vStack()
                let shareText = "Comparte el siguiente enlace con los firmantes para completar el pago."
                XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(vStack, expectedText: shareText), "Failed to find the text: \(shareText)")
                XCTAssertNoThrow(try vStack.find(KhipuClientIOS.CopyToClipboardLink.self))
            } catch {
                XCTFail("Failed to inspect view: \(error)")
            }
        }
        wait(for: [exp], timeout: 2.0)
    }
    func testDetailItemMustContinueRendersCorrectly() throws {
        let themeManager = ThemeManager()
        let viewShouldCopy = DetailItemMustContinue(label: "Label one", value: "Value one", shouldCopyValue: true).environmentObject(themeManager)
        let viewShouldNotCopy = DetailItemMustContinue(label: "Label two", value: "Value two", shouldCopyValue: false).environmentObject(themeManager)
        
        ViewHosting.host(view: viewShouldCopy)
        ViewHosting.host(view: viewShouldNotCopy)
        
        let exp = expectation(description: "onAppear")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exp.fulfill()
            do {
                let inspectedViewShouldCopy = try viewShouldCopy.inspect().view(DetailItemMustContinue.self)
                let hStackShouldCopy = try inspectedViewShouldCopy.hStack()
                
                XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(hStackShouldCopy, expectedText: "Label one"), "Failed to find the text: Label one")
                XCTAssertFalse(try ViewInspectorUtils.verifyTextInStack(hStackShouldCopy, expectedText: "Value one"))
                XCTAssertNoThrow(try hStackShouldCopy.find(CopyToClipboardOperationId.self))
                
                let inspectedViewShouldNotCopy = try viewShouldNotCopy.inspect().view(DetailItemMustContinue.self)
                let hStackShouldNotCopy = try inspectedViewShouldNotCopy.hStack()
                let valueTextColor = try hStackShouldNotCopy.text(1).attributes().foregroundColor()
                
                XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(hStackShouldNotCopy, expectedText: "Label two"), "Failed to find the text: Label two")
                XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(hStackShouldNotCopy, expectedText: "Value two"), "Failed to find the text: Value two")
                XCTAssertEqual(valueTextColor, themeManager.selectedTheme.colors.onSurface)
                
            } catch {
                XCTFail("Failed to inspect view: \(error)")
            }
        }
        wait(for: [exp], timeout: 2.0)
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
        
        ViewHosting.host(view: view)
        
        let exp = expectation(description: "onAppear")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exp.fulfill()
            do {
                let inspectView = try view.inspect().view(DetailSection.self)
                let vStack = try inspectView.vStack()
                
                XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(vStack, expectedText: "default.detail.label"), "Failed to find the text: default.detail.label")
                XCTAssertNoThrow(try vStack.view(DetailItemMustContinue.self, 1))
                XCTAssertNoThrow(try vStack.view(DetailItemMustContinue.self, 2))
                XCTAssertNoThrow(try vStack.find(DashedLine.self))
                XCTAssertNoThrow(try vStack.view(DetailItemMustContinue.self, 4))
            } catch {
                XCTFail("Failed to inspect view: \(error)")
            }
        }
        wait(for: [exp], timeout: 2.0)
    }
}
