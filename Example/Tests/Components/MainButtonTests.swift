import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS

@available(iOS 13.0, *)
final class MainButtonTests: XCTestCase {
    
    func testMainButtonRendersCorrectly() throws {
        let themeManager = ThemeManager()
        var clicked = false
        let button = MainButton(
            text: "Click Me",
            enabled: true,
            onClick: {
                clicked = true
            },
            foregroundColor: .white,
            backgroundColor: .blue
        ).environmentObject(themeManager)
        
        let inspectedView = try button.inspect().view(MainButton.self)
        let buttonView = try inspectedView.button()
        XCTAssertEqual(try buttonView.labelView().text().string(), "Click Me")
        XCTAssertEqual(buttonView.isDisabled(), false)
        XCTAssertEqual(try buttonView.labelView().text().attributes().foregroundColor(), Color.white)
 
    }
    
    func testMainButtonDisabledState() throws {
        let themeManager = ThemeManager()
        let button = MainButton(
            text: "Click Me",
            enabled: false,
            onClick: {},
            foregroundColor: .white,
            backgroundColor: .blue
        ).environmentObject(themeManager)
        
        ViewHosting.host(view: button)
        
        let inspectedView = try button.inspect().view(MainButton.self)
        let buttonView = try inspectedView.button()
        XCTAssertEqual(try buttonView.labelView().text().string(), "Click Me")
        XCTAssertEqual(buttonView.isDisabled(), true)
        XCTAssertEqual(try buttonView.labelView().text().attributes().foregroundColor(), .secondary.opacity(0.3))
    }
}
