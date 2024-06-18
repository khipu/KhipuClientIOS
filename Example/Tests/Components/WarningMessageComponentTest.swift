import XCTest
import SwiftUI
import ViewInspector
import KhenshinProtocol
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class WarningMessageComponentTest: XCTestCase {
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

        let inspectView = try view.inspect().view(WarningMessageComponent.self)
        
        let texts = inspectView.findAll(ViewType.Text.self)
        let images = inspectView.findAll(ViewType.Image.self)
        let formWarnings = inspectView.findAll(FormWarning.self)
        let detailSectionWarnings = inspectView.findAll(DetailSectionWarning.self)
        let mainButtons = inspectView.findAll(MainButton.self)
        
        
        XCTAssertEqual(try texts[0].string(), "page.operationWarning.failure.after.notify.pre.header")
        XCTAssertEqual(try texts[1].string(), operationWarning.title)
        XCTAssertGreaterThanOrEqual(images.count, 1)
        XCTAssertEqual(formWarnings.count, 1)
        XCTAssertEqual(detailSectionWarnings.count, 1)
        XCTAssertEqual(mainButtons.count, 1)
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
        
        let inspectView = try view.inspect().view(DetailSectionWarning.self)
        let texts = inspectView.findAll(ViewType.Text.self)
        let detailItemWarnings = inspectView.findAll(DetailItemWarning.self)
        
        XCTAssertEqual(try texts[0].string(), "default.detail.label")
        XCTAssertEqual(detailItemWarnings.count, 3)

    }
    
    func testDetailItemWarning() throws {
        
        let themeManager = ThemeManager()
        let view = DetailItemWarning(label: "Label", value: "Value", shouldCopyValue: true).environmentObject(themeManager)
        
        let inspectView = try view.inspect().view(DetailItemWarning.self)
        let texts = inspectView.findAll(ViewType.Text.self)
        XCTAssertEqual(try texts[0].string(), "Label")
        XCTAssertFalse(try ViewInspectorUtils.verifyTextInStack(inspectView, expectedText: "Value"))
        XCTAssertNoThrow(try inspectView.find(CopyToClipboardOperationId.self))
        XCTAssertEqual(inspectView.findAll(CopyToClipboardOperationId.self).count, 1)
    }
    
    func testDetailItemWarningNoCopy() throws {
        let themeManager = ThemeManager()
        let view = DetailItemWarning(label: "Label", value: "Value", shouldCopyValue: false).environmentObject(themeManager)
        
        let inspectView = try view.inspect().view(DetailItemWarning.self)
        let texts = inspectView.findAll(ViewType.Text.self)
        XCTAssertEqual(texts.count, 2)
        XCTAssertEqual(try texts[0].string(), "Label")
        XCTAssertEqual(try texts[1].string(), "Value")
        XCTAssertEqual(inspectView.findAll(CopyToClipboardOperationId.self).count, 0)
    }
}
