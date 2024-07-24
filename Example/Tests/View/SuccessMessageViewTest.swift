import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS
import KhenshinProtocol

@available(iOS 15.0, *)
final class SuccessMessageViewTest: XCTestCase {
    
    func testSuccessMessageViewRendersCorrectly() throws {
        let themeManager = ThemeManager()
       
        let view = SuccessMessageView(operationSuccess: MockDataGenerator.createOperationSuccess(body:"Enviaremos el comprobante  de pago a tu correo",title: "¡Listo, transferiste!"), translator: MockDataGenerator.createTranslator(), operationInfo: MockDataGenerator.createOperationInfo(), returnToApp: {})
            .environmentObject(themeManager)

        let inspectView = try view.inspect().view(SuccessMessageView.self)

        XCTAssertNoThrow(try inspectView.find(text: "Enviaremos el comprobante  de pago a tu correo"))
        XCTAssertNoThrow(try inspectView.find(text: "¡Listo, transferiste!"))
        XCTAssertNoThrow(try inspectView.find(text: MockDataGenerator.createTranslator().t("default.amount.label")))
        XCTAssertNoThrow(try inspectView.find(text: MockDataGenerator.createTranslator().t("default.merchant.label")))
        XCTAssertNoThrow(try inspectView.find(text: MockDataGenerator.createTranslator().t("default.operation.code.label")))
    }
    
    func testSuccessMessageViewNotOperationInfoRendersCorrectly() throws {
        let themeManager = ThemeManager()
       
        let view = SuccessMessageView(operationSuccess: MockDataGenerator.createOperationSuccess(body:"Enviaremos el comprobante  de pago a tu correo",title: "¡Listo, transferiste!"), translator: MockDataGenerator.createTranslator(), returnToApp: {})
            .environmentObject(themeManager)

        let inspectView = try view.inspect().view(SuccessMessageView.self)

        XCTAssertNoThrow(try inspectView.find(text: "Enviaremos el comprobante  de pago a tu correo"))
        XCTAssertNoThrow(try inspectView.find(text: "¡Listo, transferiste!"))
        XCTAssertThrowsError(try inspectView.find(text: MockDataGenerator.createTranslator().t("default.amount.label")))
        XCTAssertThrowsError(try inspectView.find(text: MockDataGenerator.createTranslator().t("default.merchant.label")))
        XCTAssertNoThrow(try inspectView.find(text: MockDataGenerator.createTranslator().t("default.operation.code.label")))
    }
}
