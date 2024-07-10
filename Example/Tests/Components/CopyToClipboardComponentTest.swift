import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class CopyToClipboardComponentTest: XCTestCase {
    
    func testCopyToClipboardOperationId() throws {
        let themeManager = ThemeManager()
        let view = CopyToClipboardOperationId(text: "Copy this", textToCopy: "Text to be copied", background: .gray)
            .environmentObject(themeManager)
        
        let inspectedView = try view.inspect().view(CopyToClipboardOperationId.self)
        let button = try inspectedView.button()
        XCTAssertNotNil(try? inspectedView.find(text: "Copy this"), "Failed to find the text: Copy this")
                
    }
    
    func testCopyToClipboardLink() throws {
        let themeManager = ThemeManager()
        let view = CopyToClipboardLink(text: "Copy this link", textToCopy: "Link to be copied", background: .blue)
            .environmentObject(themeManager)
        
        let inspectedView = try view.inspect().view(CopyToClipboardLink.self)
        let button = try inspectedView.button()
        XCTAssertNotNil(try? inspectedView.find(text: "Copy this link"), "Failed to find the text: Copy this link")
    }
}
