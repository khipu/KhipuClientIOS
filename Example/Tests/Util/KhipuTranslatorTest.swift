import XCTest
@testable import KhipuClientIOS

final class KhipuTranslatorTest: XCTestCase {
    func testTranslator() throws {
        let translator = KhipuTranslator(
            translations: [
                "default.button.label": "Send",
                "default.email.title": "Enter email"
            ])
        XCTAssertEqual(translator.t("default.button.label"), "Send")
        XCTAssertEqual(translator.t("default.email.title"), "Enter email")
        XCTAssertEqual(translator.t("default.title"), "default.title")
        XCTAssertEqual(translator.t(""), "")
        
        XCTAssertEqual(translator.t("default.title", default: "Title"), "Title")
        XCTAssertEqual(translator.t("", default: "Empty"), "Empty")
        
    }
}
