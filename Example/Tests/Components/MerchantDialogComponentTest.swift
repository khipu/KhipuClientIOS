import XCTest
import SwiftUI
import ViewInspector
import KhenshinProtocol
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class MerchantDialogComponentTest: XCTestCase {
    
    
    func testMerchantDialogComponentRendering() throws {
        
        let merchant = "Demo Merchant"
        let subject = "Demo Subject"
        let description = "Descripción de la operación"
        let amount = "$100.00"
        
        
        let view = MerchantDialogComponent(
            onDismissRequest: { },
            translator: MockDataGenerator.createTranslator(),
            merchant: merchant,
            subject: subject,
            description: description,
            amount: amount).environmentObject(ThemeManager())
        
        let inspectedView = try view.inspect().view(MerchantDialogComponent.self)
        
        XCTAssertNotNil(try? inspectedView.find(text: MockDataGenerator.createTranslator().t("modal.merchant.info.title")), "Failed to find the text: Detalles del Pago")
        
        XCTAssertNotNil(try? inspectedView.find(text: MockDataGenerator.createTranslator().t("modal.merchant.info.destinatary.label")), "Failed to find the text: Destinatario")
        
        XCTAssertNotNil(try? inspectedView.find(text: merchant), "Failed to find the text:"+merchant)
        
        XCTAssertNotNil(try? inspectedView.find(text: MockDataGenerator.createTranslator().t("modal.merchant.info.subject.label")), "Failed to find the text: Asunto")
        
        XCTAssertNotNil(try? inspectedView.find(text: subject), "Failed to find the text:"+subject)
        
        
        XCTAssertNotNil(try? inspectedView.find(text: MockDataGenerator.createTranslator().t("modal.merchant.info.description.label")), "Failed to find the text: Descripción")
        
        XCTAssertNotNil(try? inspectedView.find(text: description), "Failed to find the text:"+description)
        
        
        XCTAssertNotNil(try? inspectedView.find(text: MockDataGenerator.createTranslator().t("modal.merchant.info.amount.label")), "Failed to find the text: Monto a Pagar")
        
        XCTAssertNotNil(try? inspectedView.find(text: amount), "Failed to find the text:"+amount)
        
    }
    
}
