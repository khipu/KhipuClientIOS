import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class ToastComponentTest: XCTestCase {

    func testToastComponentView() throws {
        let themeManager = ThemeManager()
        let view = ToastComponent(text: "Error de conexion")
            .environmentObject(themeManager)
        
        let inspectedView = try view.inspect()
        XCTAssertNotNil(try? inspectedView.find(text: "Error de conexion"), "Failed to find the text: Title")
    }
}
