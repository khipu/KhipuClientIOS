import XCTest
import SwiftUI
import ViewInspector

@testable import khenshinClientIos

@available(iOS 15.0, *)
extension MerchantDialogComponent: Inspectable { }

@available(iOS 15.0, *)
final class MerchantDialogComponentTests: XCTestCase {
    
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
            
            let titleText = try view.navigationView().scrollView().vStack().text(0)
            XCTAssertEqual(try titleText.string(), "Detalles del Pago")
            
            let destinataryLabelText = try view.navigationView().scrollView().vStack().text(1)
            XCTAssertEqual(try destinataryLabelText.string(), "Destinatario")
            
            let merchantText = try view.navigationView().scrollView().vStack().text(2)
            XCTAssertEqual(try merchantText.string(), merchant)
            
            let subjectLabelText = try view.navigationView().scrollView().vStack().text(3)
            XCTAssertEqual(try subjectLabelText.string(), "Asunto")
            
            let subjectText = try view.navigationView().scrollView().vStack().text(4)
            XCTAssertEqual(try subjectText.string(), subject)
            
            if !description.isEmpty {
                let descriptionLabelText = try view.navigationView().scrollView().vStack().tupleView(5).text(0)
                XCTAssertEqual(try descriptionLabelText.string(), "Descripción")
                
                let descriptionText = try view.navigationView().scrollView().vStack().tupleView(5).text(1)
                XCTAssertEqual(try descriptionText.string(), description)
                
                let amountLabelText = try view.navigationView().scrollView().vStack().text(6)
                XCTAssertEqual(try amountLabelText.string(), "Monto a Pagar")
                
                let amountText = try view.navigationView().scrollView().vStack().text(7)
                XCTAssertEqual(try amountText.string(), amount)
            } else {
                let amountLabelText = try view.navigationView().scrollView().vStack().text(5)
                XCTAssertEqual(try amountLabelText.string(), "Monto a Pagar")
                
                let amountText = try view.navigationView().scrollView().vStack().text(6)
                XCTAssertEqual(try amountText.string(), amount)
            }
        } catch {
            XCTFail("Error al intentar inspeccionar la vista: \(error)")
        }
    }
}
