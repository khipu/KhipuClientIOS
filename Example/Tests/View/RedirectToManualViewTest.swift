import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS
@testable import KhenshinProtocol

@available(iOS 15.0, *)
final class RedirectToManualViewTest: XCTestCase {

    
    func testRedirectoToManualViewRendersCorrectly() throws {
        let themeManager = ThemeManager()

        let view = RedirectToManualView(operationFailure: MockDataGenerator.createOperationFailure(reason: .bankWithoutAutomaton), translator: MockDataGenerator.createTranslator(), operationInfo: MockDataGenerator.createOperationInfo(), restartPayment:{})
            .environmentObject(themeManager)
        
        let inspectedView = try view.inspect().view(RedirectToManualView.self)
        
        XCTAssertNotNil(try? inspectedView.find(text: MockDataGenerator.createTranslator().t("page.redirectManual.redirecting")), "Failed to find the text:page.redirectManual.redirecting")

    }
     
}
