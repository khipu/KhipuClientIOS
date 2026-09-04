import XCTest
import SwiftUI
import ViewInspector
import KhenshinProtocol
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class WarningMessageComponentTest: XCTestCase {
   
    
    
    func testWarningMessageViewRendersCorrectly() throws {
        let themeManager = ThemeManager()

        
        let view = WarningMessageView(operationWarning: MockDataGenerator.createOperationWarning(), operationInfo: MockDataGenerator.createOperationInfo(), translator: MockDataGenerator.createTranslator(), returnToApp: {})
            .environmentObject(themeManager)
        
        let inspectedView = try view.inspect().view(WarningMessageView.self)
        XCTAssertNotNil(try? inspectedView.find(text: MockDataGenerator.createTranslator().t("page.operationWarning.failure.after.notify.pre.header")), "Failed to find the text: page.operationWarning.failure.after.notify.pre.header")
    }

    /// Regression guard: `title` and `operationID` are optional in the wire protocol.
    /// Force-unwrapping them aborted the app on the warning screen.
    func testRendersWhenTitleAndOperationIdAreNil() throws {
        let warning = OperationWarning(
            type: .operationWarning,
            body: "[Mensaje autómata].",
            events: nil,
            exitURL: nil,
            operationID: nil,
            resultMessage: nil,
            title: nil,
            reason: nil
        )

        let view = WarningMessageView(
            operationWarning: warning,
            operationInfo: nil,
            translator: MockDataGenerator.createTranslator(),
            returnToApp: {}
        ).environmentObject(ThemeManager())

        let inspectedView = try view.inspect().view(WarningMessageView.self)
        XCTAssertNoThrow(try inspectedView.find(MainButton.self))
    }
     
    
}
