import XCTest
import SwiftUI
import ViewInspector
import KhenshinProtocol
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class WarningMessageComponentTests: XCTestCase {
    func testWarningMessageComponentRendersCorrectly() throws {
        let themeManager = ThemeManager()
        let viewModel = KhipuViewModel()
        
        let operationWarning = OperationWarning(
            type: MessageType.operationWarning,
            body: "body",
            events: nil,
            exitURL: "exitUrl",
            operationID: "operationID",
            resultMessage: "resultMessage",
            title: "Title",
            reason: FailureReasonType.taskDumped
        )
        
        let view = WarningMessageComponent(operationWarning: operationWarning, viewModel: viewModel)
            .environmentObject(themeManager)
        
        ViewHosting.host(view: view)
        
        let exp = expectation(description: "onAppear")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exp.fulfill()
            do {
                let inspectedView = try view.inspect().view(WarningMessageComponent.self)
                let vStack = try inspectedView.vStack()
                
                XCTAssertNoThrow(try vStack.image(0))
                XCTAssertEqual(try vStack.text(1).string(), "page.operationWarning.failure.after.notify.pre.header")
                XCTAssertEqual(try vStack.text(2).string(), operationWarning.title)
                XCTAssertNoThrow(try vStack.view(FormWarning.self, 3))
                XCTAssertNoThrow(try vStack.spacer(4))
                XCTAssertNoThrow(try vStack.view(DetailSectionWarning.self, 5))
                XCTAssertNoThrow(try vStack.spacer(6))
                XCTAssertNoThrow(try vStack.view(MainButton.self, 7))
            } catch {
                XCTFail("Failed to inspect view: \(error)")
            }
        }
        wait(for: [exp], timeout: 2.0)
    }
    
    func testDetailSectionWarningRendersCorrectly() throws {
        let themeManager = ThemeManager()
        let viewModel = KhipuViewModel()
        
        let operationWarning = OperationWarning(
            type: MessageType.operationWarning,
            body: "body",
            events: nil,
            exitURL: "exitUrl",
            operationID: "operationID",
            resultMessage: "resultMessage",
            title: "Title",
            reason: FailureReasonType.taskDumped
        )

        let operationInfo = OperationInfo(
            acceptManualTransfer: true,
            amount: "$ 1.000",
            body: "body",
            email: "khipu@khipu.com",
            merchant: nil,
            operationID: "operationID",
            subject: "Subject",
            type: MessageType.operationInfo,
            urls: nil,
            welcomeScreen: nil
        )
        
        let view = DetailSectionWarning(operationWarning: operationWarning, operationInfo: operationInfo, viewModel: viewModel)
            .environmentObject(themeManager)
        
        ViewHosting.host(view: view)
        
        let exp = expectation(description: "onAppear")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exp.fulfill()
            do {
                var inspectedView = try view.inspect().view(DetailSectionWarning.self)
                let vStack = try inspectedView.vStack()
                
                XCTAssertEqual(try vStack.text(0).string(), "default.detail.label")
                XCTAssertNoThrow(try vStack.view(DetailItemWarning.self, 1))
                XCTAssertNoThrow(try vStack.view(DetailItemWarning.self, 2))
                XCTAssertNoThrow(try vStack.view(DetailItemWarning.self, 3))
            } catch {
                XCTFail("Failed to inspect view: \(error)")
            }
        }
        wait(for: [exp], timeout: 2.0)
    }
    func testDetailItemWarningRendersCorrectly() throws {
        let themeManager = ThemeManager()
        let viewShouldCopy = DetailItemWarning(label: "Label one", value: "Value one", shouldCopyValue: true).environmentObject(themeManager)
        let viewShouldNotCopy = DetailItemWarning(label: "Label two", value: "Value two", shouldCopyValue: false).environmentObject(themeManager)
        
        ViewHosting.host(view: viewShouldCopy)
        ViewHosting.host(view: viewShouldNotCopy)
        
        let exp = expectation(description: "onAppear")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exp.fulfill()
            do {
                let inspectedViewShouldCopy = try viewShouldCopy.inspect().view(DetailItemWarning.self)
                let hStackShouldCopy = try inspectedViewShouldCopy.hStack()
                
                XCTAssertEqual(try hStackShouldCopy.text(0).string(), "Label one")
                XCTAssertNoThrow(try hStackShouldCopy.spacer(1))
                XCTAssertFalse(try ViewInspectorUtils.verifyTextInStack(hStackShouldCopy, expectedText: "Value one"))
                XCTAssertNoThrow(try hStackShouldCopy.find(CopyToClipboardOperationId.self))
                
                let inspectedViewShouldNotCopy = try viewShouldNotCopy.inspect().view(DetailItemWarning.self)
                let hStackShouldNotCopy = try inspectedViewShouldNotCopy.hStack()
                
                XCTAssertEqual(try hStackShouldNotCopy.text(0).string(), "Label two")
                XCTAssertNoThrow(try hStackShouldNotCopy.spacer(1))
                XCTAssertEqual(try hStackShouldNotCopy.text(2).string(), "Value two")
                
            } catch {
                XCTFail("Failed to inspect view: \(error)")
            }
        }
        wait(for: [exp], timeout: 2.0)
    }
}
