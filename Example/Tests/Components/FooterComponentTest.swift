import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class FooterComponentTest: XCTestCase {

    
    func testFooterComponentView() throws {
        let operationCode = "aaaabbbbcccc"
        let view = FooterComponent(showFooter: true, operationCode: operationCode).environmentObject(ThemeManager())
        
        let inspectedView = try view.inspect()
        XCTAssertNotNil(try? inspectedView.find(text: "V \(KhipuVersion.version)"), "Failed to find the text: V \(KhipuVersion.version)")
        XCTAssertNotNil(try? inspectedView.find(text: "AAAA-BBBB-CCCC"), "Failed to find the text: AAAA-BBBB-CCCC")
    }
}
