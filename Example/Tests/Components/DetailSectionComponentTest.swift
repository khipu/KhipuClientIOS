import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS
@testable import KhenshinProtocol

@available(iOS 15.0, *)
final class DetailSectionComponentTest: XCTestCase {

        func testDetailSectionRendersCorrectly() throws {
            let params = DetailSectionParams(amountLabel: "monto", amountValue: "100", merchantNameLabel: "merchant", merchantNameValue: "merchant name", codOperacionLabel: "123456")
                      
            let view = DetailSectionComponent(operationId: "123456", params: params).environmentObject(ThemeManager())

            let inspectedView = try view.inspect().view(DetailSectionComponent.self)
            XCTAssertNotNil(try? inspectedView.find(text: "monto"), "Failed to find the text: monto")
            XCTAssertNotNil(try? inspectedView.find(text: "100"), "Failed to find the text: 100")
            XCTAssertNotNil(try? inspectedView.find(text: "merchant"), "Failed to find the text: merchant")
            XCTAssertNotNil(try? inspectedView.find(text: "merchant name"), "Failed to find the text: merchant name")
            XCTAssertNotNil(try? inspectedView.find(text: "123456"), "Failed to find the text: 123456")
        }

        func testDetailItemRendersCorrectly() throws {
            let view = DetailItem(label: "Label", value: "Value")
                .environmentObject(ThemeManager())

            let inspectedView = try view.inspect().view(DetailItem.self)
            XCTAssertNotNil(try? inspectedView.find(text: "Label"), "Failed to find the text: Label")
            XCTAssertNotNil(try? inspectedView.find(text: "Value"), "Failed to find the text: Value")

        }
 
}
