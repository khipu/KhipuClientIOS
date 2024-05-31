import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS

@available(iOS 13.0, *)
extension DashedLine: Inspectable { }

@available(iOS 13.0, *)
extension Line: Inspectable { }

@available(iOS 15.0, *)
final class DasehdLineTests: XCTestCase {

    func testDashedLineView() throws {
        let view = DashedLine()
        let inspectedView = try view.inspect()
        let strokeStyleModifier = try inspectedView.shape(0).strokeStyle()
        XCTAssertEqual(strokeStyleModifier.lineWidth, 1)
        XCTAssertEqual(strokeStyleModifier.dash, [5])
    }
}
