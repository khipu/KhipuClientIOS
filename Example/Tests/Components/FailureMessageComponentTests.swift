import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS
@testable import KhenshinProtocol

@available(iOS 15.0, *)
final class FailureMessageComponentTests: XCTestCase {

    func testFailureMessageComponentRendersCorrectly() throws {
        let themeManager = ThemeManager()
        let viewModel = KhipuViewModel()
        let operationFailure = OperationFailure(
            type: .operationFailure,
            body: "The operation could not be completed",
            events: nil,
            exitURL: nil,
            operationID: "12345",
            resultMessage: nil,
            title: "Operation Failed",
            reason: .noBackendAvailable
        )
        
        let view = FailureMessageComponent(operationFailure: operationFailure, viewModel: viewModel)
            .environmentObject(themeManager)
        
        ViewHosting.host(view: view)
        
        let exp = expectation(description: "onAppear")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exp.fulfill()
            do {
                let inspectedView = try view.inspect().view(FailureMessageComponent.self)
                let vStack = try inspectedView.vStack()
                
                XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(vStack, expectedText: "Operation Failed"), "Failed to find the text: Operation Failed")
            } catch {
                XCTFail("Failed to inspect view: \(error)")
            }
        }
        
        wait(for: [exp], timeout: 2.0)
    }

            
        func testDetailSectionFailureRendersCorrectly() throws {
            let themeManager = ThemeManager()
            let viewModel = KhipuViewModel()
            viewModel.uiState.translator = KhipuTranslator(translations: [
                "default.detail.label": "Detalle",
            ])
            let operationFailure = OperationFailure(
                type: .operationFailure,
                body: "The operation could not be completed",
                events: nil,
                exitURL: nil,
                operationID: "12345",
                resultMessage: nil,
                title: "Operation Failed",
                reason: .noBackendAvailable
            )
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
            
            let view = DetailSectionFailure(operationFailure: operationFailure, operationInfo: operationInfo, viewModel: viewModel)
                .environmentObject(themeManager)
            
            ViewHosting.host(view: view)
            
            let exp = expectation(description: "onAppear")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                exp.fulfill()
                do {
                    let inspectedView = try view.inspect().view(DetailSectionFailure.self)
                    let vStack = try inspectedView.vStack()
                    
                    XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(vStack, expectedText: "Detalle"), "Failed to find the text: Detalle")
                } catch {
                    XCTFail("Failed to inspect view: \(error)")
                }
            }
            
            wait(for: [exp], timeout: 2.0)
        }

    func testDetailItemFailureRendersCorrectly() throws {
        let themeManager = ThemeManager()
        let view = DetailItemFailure(label: "Label", value: "Value")
            .environmentObject(themeManager)
        
        ViewHosting.host(view: view)
        
        let exp = expectation(description: "onAppear")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exp.fulfill()
            do {
                let inspectedView = try view.inspect().view(DetailItemFailure.self)
                let hStack = try inspectedView.hStack()
                
                XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(hStack, expectedText: "Label"), "Failed to find the text: Label")
                XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(hStack, expectedText: "Value"), "Failed to find the text: Value")
                
            } catch {
                XCTFail("Failed to inspect view: \(error)")
            }
        }
        
        wait(for: [exp], timeout: 2.0)
    }
}
