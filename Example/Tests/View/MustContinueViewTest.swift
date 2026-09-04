import XCTest
import SwiftUI
import ViewInspector
import KhenshinProtocol
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class MustContinueViewTest: XCTestCase {
    
    func testMustContinueComponentRendersCorrectly() throws {
        let themeManager = ThemeManager()

        let view = MustContinueView(operationMustContinue: MockDataGenerator.createOperationMustContinue(), translator: MockDataGenerator.createTranslator(), operationInfo: MockDataGenerator.createOperationInfo(), returnToApp:{})
            .environmentObject(themeManager)
        
        let inspectedView = try view.inspect().view(MustContinueView.self)
        
        XCTAssertNotNil(try? inspectedView.find(text: MockDataGenerator.createTranslator().t("page.operationFailure.header.text.operation.task.finished")), "Failed to find the text: Pago en verificación")
        XCTAssertNotNil(try? inspectedView.find(text: MockDataGenerator.createTranslator().t("default.end.and.go.back")), "Failed to find the text: Pago en verificación")
        XCTAssertNoThrow(try inspectedView.find(MainButton.self))
    }
    
    func testInformationSectionRendersCorrectly() throws {
        let themeManager = ThemeManager()
        
        let view = InformationSection(translator: MockDataGenerator.createTranslator(), operationInfo: MockDataGenerator.createOperationInfo()).environmentObject(themeManager)
        
        let inspectedView = try view.inspect().view(InformationSection.self)
        XCTAssertNotNil(try? inspectedView.find(text: MockDataGenerator.createTranslator().t("page.operationMustContinue.share.description")), "Failed to find the text: page.operationMustContinue.share.description")

        XCTAssertNoThrow(try inspectedView.find(CopyToClipboardLink.self))
    }

    /// Regression guard: `title`, `operationID` and `amount` are all optional in the
    /// wire protocol. Force-unwrapping them aborted the app on this screen.
    func testRendersWhenTitleOperationIdAndAmountAreNil() throws {
        let view = MustContinueView(
            operationMustContinue: MustContinueViewTest.emptyMustContinue(),
            translator: MockDataGenerator.createTranslator(),
            operationInfo: MustContinueViewTest.emptyOperationInfo(),
            returnToApp: {}
        ).environmentObject(ThemeManager())

        let inspectedView = try view.inspect().view(MustContinueView.self)
        XCTAssertNoThrow(try inspectedView.find(MainButton.self))
    }

    /// The ShareLink built `URL(string:)!` out of `urls.info`, which is optional in the
    /// protocol, so a missing info URL aborted the screen. The link is now conditional
    /// on the URL parsing, and the rest of the section still renders without it.
    func testInformationSectionRendersWhenInfoUrlIsMissing() throws {
        let view = InformationSection(
            translator: MockDataGenerator.createTranslator(),
            operationInfo: MustContinueViewTest.emptyOperationInfo()
        ).environmentObject(ThemeManager())

        let inspectedView = try view.inspect().view(InformationSection.self)
        XCTAssertNoThrow(try inspectedView.find(CopyToClipboardLink.self))
    }

    private static func emptyMustContinue() -> OperationMustContinue {
        OperationMustContinue(
            type: .operationMustContinue,
            body: "[Mensaje autómata].",
            events: nil,
            exitURL: nil,
            operationID: nil,
            resultMessage: nil,
            title: nil,
            reason: nil
        )
    }

    private static func emptyOperationInfo() -> OperationInfo {
        OperationInfo(
            acceptManualTransfer: nil,
            amount: nil,
            body: nil,
            email: nil,
            merchant: nil,
            operationID: nil,
            sessionReplaySaved: nil,
            subject: nil,
            type: .operationInfo,
            urls: nil,
            welcomeScreen: nil
        )
    }
}
