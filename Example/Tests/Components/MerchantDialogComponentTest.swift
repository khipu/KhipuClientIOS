import XCTest
import SwiftUI
import ViewInspector
import KhenshinProtocol
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class MerchantDialogComponentTest: XCTestCase {
    
    
    func testMerchantDialogComponentRendering() throws {
        
        let translations: [String: String] = [
            "modal.merchant.info.title": "Detalles del Pago",
            "modal.merchant.info.destinatary.label": "Destinatario",
            "modal.merchant.info.subject.label": "Asunto",
            "modal.merchant.info.description.label": "Descripción",
            "modal.merchant.info.amount.label": "Monto a Pagar",
            "modal.merchant.info.close.button": "Cerrar"
        ]
        
        let translator = KhipuTranslator(translations: translations)
        let merchant = "Demo Merchant"
        let subject = "Demo Subject"
        let description = "Descripción de la operación"
        let amount = "$100.00"
        
        
        let view = MerchantDialogComponent(
            onDismissRequest: { },
            translator: translator,
            merchant: merchant,
            subject: subject,
            description: description,
            amount: amount).environmentObject(ThemeManager())
        
        let inspectedView = try view.inspect().view(MerchantDialogComponent.self)
        XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(inspectedView, expectedText: "Detalles del Pago"), "Failed to find the text: Detalles del Pago")
        
        XCTAssertNotNil(try? inspectedView.find(text: "Destinatario"), "Failed to find the text: Destinatario")
        
        XCTAssertNotNil(try? inspectedView.find(text: merchant), "Failed to find the text:"+merchant)
        
        XCTAssertNotNil(try? inspectedView.find(text: "Asunto"), "Failed to find the text: Asunto")
        
        XCTAssertNotNil(try? inspectedView.find(text: subject), "Failed to find the text:"+subject)
        
        
        XCTAssertNotNil(try? inspectedView.find(text: "Descripción"), "Failed to find the text: Descripción")
        
        XCTAssertNotNil(try? inspectedView.find(text: description), "Failed to find the text:"+description)
        
        
        XCTAssertNotNil(try? inspectedView.find(text: "Monto a Pagar"), "Failed to find the text: Monto a Pagar")
        
        XCTAssertNotNil(try? inspectedView.find(text: amount), "Failed to find the text:"+amount)
        
    }
    
}
