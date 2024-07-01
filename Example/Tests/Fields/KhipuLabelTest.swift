import XCTest
import SwiftUI
import ViewInspector
import KhenshinProtocol

@testable import KhipuClientIOS

@available(iOS 15.0.0, *)
final class KhipuLabelTest: XCTestCase {
    
    func testSwitchFieldView_Fill() throws {
        let view = FieldLabel(text: "Some stuff", font: .body)
        
        let instected = try view.environmentObject(ThemeManager()).inspect()
        
        let text = try instected.find(viewWithAccessibilityIdentifier: "labelText").text().string()
        XCTAssertEqual(text, "Some stuff")
    }
    
    func testSwitchFieldView_Empty() throws {
        let view = FieldLabel(font: .body)
        
        let instected = try view.environmentObject(ThemeManager()).inspect()
        
        XCTAssertThrowsError(try instected.find(viewWithAccessibilityIdentifier: "labelText"), "label not found") { error in
            // Optionally verify the error type or message if needed
            XCTAssertTrue(error is InspectionError, "label not found")
        }
    }
}
