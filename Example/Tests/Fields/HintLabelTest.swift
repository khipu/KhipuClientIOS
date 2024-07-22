import XCTest
import SwiftUI
import ViewInspector
import KhenshinProtocol

@testable import KhipuClientIOS

@available(iOS 15.0.0, *)
final class HintLabelTest: XCTestCase {
    
    func testHintLabelView_Fill() throws {
        let view = HintLabel(text: "Some stuff")
        
        let instected = try view.environmentObject(ThemeManager()).inspect()
        
        let text = try instected.find(viewWithAccessibilityIdentifier: "hintText").text().string()
        XCTAssertEqual(text, "Some stuff")
    }
    
    func testHintLabelView_Empty() throws {
        let view = HintLabel()
        
        let instected = try view.environmentObject(ThemeManager()).inspect()
        
        XCTAssertThrowsError(try instected.find(viewWithAccessibilityIdentifier: "hintText"), "label not found") { error in
            XCTAssertTrue(error is InspectionError, "label not found")
        }
    }
}
