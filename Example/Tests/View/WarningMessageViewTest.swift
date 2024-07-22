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
     
    
}
