import XCTest
import SwiftUI
import KhenshinProtocol
import ViewInspector
@testable import KhipuClientIOS

final class KhipuTextFieldStyleTest: XCTestCase {
    func testKhipuTextFieldStyle() throws {
        let themeManager = ThemeManager()
        let view = ContentView().environmentObject(themeManager)
        let textFields = try view.inspect().findAll(ViewType.TextField.self)
        
        XCTAssertEqual(textFields.count, 2)
        
        let overlay = try textFields[0].find(ViewType.Overlay.self)
        XCTAssertNoThrow(try overlay.find(ViewType.Shape.self))
        
        let overlay2 = try textFields[1].find(ViewType.Overlay.self)
        XCTAssertNoThrow(try overlay2.find(ViewType.Shape.self))
         
    }
}
