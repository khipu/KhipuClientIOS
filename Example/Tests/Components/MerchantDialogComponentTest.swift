import XCTest
import SwiftUI
import ViewInspector

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
        
        let component = MerchantDialogComponent(
            onDismissRequest: { },
            translator: translator,
            merchant: merchant,
            subject: subject,
            description: description,
            amount: amount
        )
        
        let hostingController = UIHostingController(rootView: component)
        XCTAssertNotNil(hostingController.view, "La vista debe inicializarse correctamente.")
        
        hostingController.view.accessibilityIdentifier = "MerchantDialogComponent"
        XCTAssertEqual(hostingController.view.accessibilityIdentifier, "MerchantDialogComponent")
        
        do {
            let view = try component.inspect()
            
            let vStack = try view.navigationView().scrollView().vStack()
            
            XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(vStack, expectedText: "Detalles del Pago"), "Failed to find the text: Detalles del Pago")
            
            XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(vStack, expectedText: "Destinatario"), "Failed to find the text: Destinatario")
            
            XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(vStack, expectedText: merchant), "Failed to find the text:"+merchant)
            
            XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(vStack, expectedText: "Asunto"), "Failed to find the text: Asunto")
            
            XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(vStack, expectedText: subject), "Failed to find the text:"+subject)
            
            if !description.isEmpty {
                let descriptionLabelText = try vStack.tupleView(5).text(0)
                XCTAssertEqual(try descriptionLabelText.string(), "Descripción")
                
                let descriptionText = try vStack.tupleView(5).text(1)
                XCTAssertEqual(try descriptionText.string(), description)
                
                let amountLabelText = try vStack.text(6)
                XCTAssertEqual(try amountLabelText.string(), "Monto a Pagar")
                
                let amountText = try vStack.text(7)
                XCTAssertEqual(try amountText.string(), amount)
            } else {
                let amountLabelText = try vStack.text(5)
                XCTAssertEqual(try amountLabelText.string(), "Monto a Pagar")
                
                let amountText = try vStack.text(6)
                XCTAssertEqual(try amountText.string(), amount)
            }
        } catch {
            XCTFail("Error al intentar inspeccionar la vista: \(error)")
        }
    }
}
