import XCTest
@testable import KhipuClientIOS

final class DimensTest: XCTestCase {
    func testDimensAreScaledCorrectyl() throws {
        let dimens = Dimens.init()
        XCTAssertEqual(dimens.none, 0)
        XCTAssertEqual(dimens.medium * 2, dimens.large)
        XCTAssertEqual(dimens.extraSmall * 2, dimens.extraMedium)
    }
}
