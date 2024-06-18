import XCTest
import ViewInspector
import SwiftUI
import KhenshinProtocol
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class SkeletonHeaderComponentTest: XCTestCase {
    func testSkeletonHeaderComponentRendersCorrectly() throws {
        let themeManager = ThemeManager()
        let view = SkeletonHeaderComponent().environmentObject(themeManager)

        let inspectView = try view.inspect().view(SkeletonHeaderComponent.self)
        let dividers = inspectView.findAll(ViewType.Divider.self)
        
        let shapes = inspectView.findAll(ViewType.Shape.self)

        XCTAssertEqual(dividers.count, 1)
        XCTAssertGreaterThanOrEqual(shapes.count, 7)
    }
}
