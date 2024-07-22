import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class EndToEndEncryptionTests: XCTestCase {
    
    func testFormInfoView() throws {
        let themeManager = ThemeManager()
        let view = EndToEndEncryptionView(translator: MockDataGenerator.createTranslator())
            .environmentObject(themeManager)
        
        let inspectedView = try view.inspect()
        
        XCTAssertNotNil(try? inspectedView.find(text: MockDataGenerator.createTranslator().t("default.end.to.end.encryption")), "Failed to find the text")
        
    }
    
}
