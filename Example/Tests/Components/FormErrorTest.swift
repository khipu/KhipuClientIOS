import XCTest
import SwiftUI
import ViewInspector
import KhenshinProtocol

@testable import KhipuClientIOS

@available(iOS 15.0.0, *)
final class FormErrorTest: XCTestCase {
    
    func testFormError_Fill() throws {
        let view = FormError(text: "Some stuff")
        let inspectedView = try view.environmentObject(ThemeManager()).inspect()
        XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(inspectedView, expectedText: "Some stuff"), "Failed to find the text: Information")

    }
    
    func testFormErrorView_Empty() throws {
        let view = FormError()
        
        let inspected = try view.environmentObject(ThemeManager()).inspect()
        
        XCTAssertThrowsError(try inspected.hStack().text(0).string(), "error not found") { error in
            XCTAssertTrue(error is InspectionError, "error not found")
        }
    }
}
