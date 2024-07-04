import XCTest
@testable import KhipuClientIOS

final class DimensTest: XCTestCase {
    func testDimensAreScaledCorrectyl() throws {
        XCTAssertEqual(Dimens.Padding.medium * 2, Dimens.Padding.large)
        XCTAssertEqual(Dimens.Padding.extraSmall * 2, Dimens.Padding.extraMedium)
    }
}
