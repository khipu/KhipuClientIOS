import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class DasehdLineTests: XCTestCase {

    func testFormInfoView() throws {
        let themeManager = ThemeManager()
        let view = DashedLine()
            .environmentObject(themeManager)
        
        ViewHosting.host(view: view)
                
        let inspectedView = try view.inspect().view(Line.self)
        XCTAssertNotNil(inspectedView)

    }
}
