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
        
        ViewHosting.host(view: button)
        
        let exp = expectation(description: "onAppear")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exp.fulfill()
            do {
                let inspectedView = try button.inspect().view(MainButton.self)
                let buttonView = try inspectedView.button()
                XCTAssertEqual(try buttonView.labelView().text().string(), "Click Me")
                XCTAssertEqual(try buttonView.isDisabled(), false)
                XCTAssertEqual(try buttonView.labelView().text().attributes().foregroundColor(), Color.white)
                
            } catch {
                XCTFail("Failed to inspect view: \(error)")
            }
        }
        
        wait(for: [exp], timeout: 2.0)
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
        XCTAssertEqual(try buttonView.isDisabled(), true)
        XCTAssertEqual(try buttonView.labelView().text().attributes().foregroundColor(), .secondary.opacity(0.3))
    }
}
