import XCTest
import SwiftUI
@testable import KhipuClientIOS

@available(iOS 13.0, *)
class SVGImageTests: XCTestCase {
    func testSVGImage() throws {
        XCTAssertNoThrow(SVGImage(url: "https://khipu.com/image.svg", svg: nil, width: 100, height: 100, percentage: 1.0))
        XCTAssertNoThrow(SVGImage(url: nil, svg: "<svg></svg>", width: 100, height: 100, percentage: 1.0))
    }
}
