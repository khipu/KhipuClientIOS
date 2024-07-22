import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class FooterComponentTest: XCTestCase {

    
    func testFooterComponentView() throws {
        let themeManager = ThemeManager()
        let view = FooterComponent(translator: MockDataGenerator.createTranslator(), showFooter: true).environmentObject(themeManager)
        
        let inspectedView = try view.inspect()
        XCTAssertNotNil(try? inspectedView.find(text: MockDataGenerator.createTranslator().t("footer.powered.by")), "Failed to find the text: footer.powered.by")
    }
     
}
