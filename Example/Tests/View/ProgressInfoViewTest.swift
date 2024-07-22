import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS

@available(iOS 15.0,*)
final class ProgressInfoViewTest: XCTestCase {
    
    
    func testProgressInfoComponentRendersCorrectly() throws {
        let themeManager = ThemeManager()
        let message = "Loading message"
        let view = ProgressInfoView(message: message)
            .environmentObject(
                themeManager
            )
        ViewHosting.host(
            view: view
        )

        let inspectedView = try view.inspect().view(
            ProgressInfoView.self
        )
        
        
        XCTAssertNotNil(try? inspectedView.find(text: message), "Failed to find the text:"+message)

    }
     
}
