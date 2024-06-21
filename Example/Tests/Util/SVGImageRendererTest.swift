import XCTest
@testable import KhipuClientIOS

class SVGImageRendererTests: XCTestCase {
    func testInitWithNilUrlAndSvg() {
        XCTAssertThrowsError(try SVGImageRenderer(url: nil, svg: nil, width: 100, height: 100, percentage: 1.0)) { error in
            XCTAssertEqual(error as? SVGImageRendererError, .onlyOneImageAllowed)
        }
    }

    func testInitWithUrl() {
        let renderer = try! SVGImageRenderer(url: "https://khipu.com", svg: nil, width: 100, height: 100, percentage: 1.0)
        XCTAssertNotNil(renderer)
    }

    func testInitWithSvg() {
        let renderer = try! SVGImageRenderer(url: nil, svg: "<svg></svg>", width: 100, height: 100, percentage: 1.0)
        XCTAssertNotNil(renderer)
    }
}
