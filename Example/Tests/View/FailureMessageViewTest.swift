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
}
