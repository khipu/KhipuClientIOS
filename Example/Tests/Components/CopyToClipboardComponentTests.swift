import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS

@available(iOS 15.0, *)
extension CopyToClipboardOperationId: Inspectable { }

@available(iOS 15.0, *)
extension CopyToClipboardLink: Inspectable { }

@available(iOS 15.0, *)
final class CopyToClipboardComponentTests: XCTestCase {
    
    func testCopyToClipboardOperationId() throws {
        let themeManager = ThemeManager()
        let view = CopyToClipboardOperationId(text: "Copy this", textToCopy: "Text to be copied", background: .gray)
            .environmentObject(themeManager)
        
        ViewHosting.host(view: view)
        
        let exp = expectation(description: "onAppear")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exp.fulfill()
            do {
                let inspectedView = try view.inspect().view(CopyToClipboardOperationId.self)
                let button = try inspectedView.button()
                let hStack = try button.labelView().hStack()
                
                XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(hStack, expectedText: "Copy this"), "Failed to find the text: Copy this")
                
                try button.tap()
                XCTAssertEqual(UIPasteboard.general.string, "Text to be copied")
            } catch {
                XCTFail("Failed to inspect view: \(error)")
            }
        }
        
        wait(for: [exp], timeout: 2.0)
    }
    
    func testCopyToClipboardLink() throws {
        let themeManager = ThemeManager()
        let view = CopyToClipboardLink(text: "Copy this link", textToCopy: "Link to be copied", background: .blue)
            .environmentObject(themeManager)
        
        ViewHosting.host(view: view)
        
        let exp = expectation(description: "onAppear")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exp.fulfill()
            do {
                let inspectedView = try view.inspect().view(CopyToClipboardLink.self)
                let button = try inspectedView.button()
                let hStack = try button.labelView().hStack()
                
                XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(hStack, expectedText: "Copy this link"), "Failed to find the text: Copy this link")
                
                try button.tap()
                XCTAssertEqual(UIPasteboard.general.string, "Link to be copied")
            } catch {
                XCTFail("Failed to inspect view: \(error)")
            }
        }
        
        wait(for: [exp], timeout: 2.0)
    }
}
