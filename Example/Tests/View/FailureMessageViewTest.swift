import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS
@testable import KhenshinProtocol

@available(iOS 15.0, *)
final class FailureMessageViewTest: XCTestCase {
    
    
    func testFailureMessageComponentRendersCorrectly() throws {

        let view = FailureMessageView(operationFailure: MockDataGenerator.createOperationFailure(), operationInfo: MockDataGenerator.createOperationInfo(), translator: MockDataGenerator.createTranslator(), returnToApp: {})
            .environmentObject(ThemeManager())
        
        let inspectedView = try view.inspect().view(FailureMessageView.self)
        XCTAssertNotNil(try? inspectedView.find(text: MockDataGenerator.createTranslator().t("page.operationFailure.header.text.operation.task.finished")), "Failed to find the text: page.operationFailure.header.text.operation.task.finished")
    }

    /// Regression guard: `title` and `operationID` are optional in the wire protocol,
    /// so the backend can legitimately omit them. Force-unwrapping them aborted the
    /// app on the failure screen. Rendering must survive nil.
    func testRendersWhenTitleAndOperationIdAreNil() throws {
        let failure = OperationFailure(
            type: .operationFailure,
            body: "[Mensaje autómata].",
            events: nil,
            exitURL: nil,
            operationID: nil,
            resultMessage: nil,
            title: nil,
            reason: nil
        )

        let view = FailureMessageView(
            operationFailure: failure,
            operationInfo: nil,
            translator: MockDataGenerator.createTranslator(),
            returnToApp: {}
        ).environmentObject(ThemeManager())

        let inspectedView = try view.inspect().view(FailureMessageView.self)
        XCTAssertNoThrow(try inspectedView.find(MainButton.self))
    }
}
