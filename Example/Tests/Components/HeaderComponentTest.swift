import XCTest
import SwiftUI
import ViewInspector
import KhenshinProtocol
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class HeaderComponentTest: XCTestCase {
    
    func testHeaderComponentRendersCorrectly() throws {
        let themeManager = ThemeManager()

        let view = HeaderComponent(showMerchantLogo: true, showPaymentDetails: true,operationInfo: MockDataGenerator.createOperationInfo(amount:"1000",merchantLogo: "logo",merchantName: "Merchant Name",operationID: "12345",subject: "Transaction Subject"), translator: MockDataGenerator.createTranslator())
            .environmentObject(themeManager)
        
        let inspectedView = try view.inspect().view(HeaderComponent.self)
        let vStack = try inspectedView
            .vStack()
        
        XCTAssertNotNil(try? inspectedView.find(text: "Merchant Name"), "Failed to find the text: Merchant Name")
        XCTAssertNotNil(try? inspectedView.find(text: "Transaction Subject"), "Failed to find the text: Transaction Subject")
        XCTAssertNotNil(try? inspectedView.find(text: MockDataGenerator.createTranslator().t("header.amount")), "Failed to find the text: MONTO A PAGAR")
        XCTAssertNotNil(try? inspectedView.find(text: "1000"), "Failed to find the text: 1000")
        XCTAssertNotNil(try? inspectedView.find(text: "CÓDIGO • 12345"), "Failed to find the text: CÓDIGO • 12345")
        XCTAssertNotNil(try? inspectedView.find(text: MockDataGenerator.createTranslator().t("header.details.show")), "Failed to find the text: Ver detalle")
    }
    
}
