import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS

@available(iOS 15.0.0, *)
final class LocationAccessRequestComponentTests: XCTestCase {

    func testLocationRequestWarningViewRendersCorrectly() throws {
        let translator = MockDataGenerator.createTranslator()
        let themeManager = ThemeManager()
        let expectationContinue = expectation(description: "Continue button tapped")
        let expectationDecline = expectation(description: "Decline button tapped")
        
        let view = LocationRequestWarningView(
            translator: translator,
            operationId: "test-operation",
            bank: "Test Bank",
            continueButton: { expectationContinue.fulfill() },
            declineButton: { expectationDecline.fulfill() }
        ).environmentObject(themeManager)
        
        let inspector = try view.inspect()

        let titleText = try inspector.find(text: translator.t("geolocation.warning.title").replacingOccurrences(of: "{{bank}}", with: "Test Bank")).string()
        XCTAssertEqual(titleText, "Test Bank solicita comprobar tu ubicación")
        
        let descriptionText = try inspector.find(text: translator.t("geolocation.warning.description")).string()
        XCTAssertEqual(descriptionText, "A continuación, se solicitará conocer tu ubicación.")
        
        let continueButton = try inspector.find(button: translator.t("geolocation.warning.button.continue"))
        XCTAssertEqual(try continueButton.labelView().text().string(), "Ir a activar ubicación")
        try continueButton.tap()
        
        let declineButton = try inspector.find(button: translator.t("geolocation.warning.button.decline"))
        XCTAssertEqual(try declineButton.labelView().text().string(), "No activar ubicación")
        try declineButton.tap()
        
        wait(for: [expectationContinue, expectationDecline], timeout: 1.0)
    }
    
    func testLocationAccessErrorViewRendersCorrectly() throws {
        let translator = MockDataGenerator.createTranslator()
        let themeManager = ThemeManager()
        let expectationContinue = expectation(description: "Continue button tapped")
        let expectationDecline = expectation(description: "Decline button tapped")
        
        let view = LocationAccessErrorView(
            translator: translator,
            operationId: "test-operation",
            bank: "Test Bank",
            continueButton: { expectationContinue.fulfill() },
            declineButton: { expectationDecline.fulfill() }
        ).environmentObject(themeManager)
        
        let inspector = try view.inspect()

        let titleText = try inspector.find(text: translator.t("geolocation.blocked.title")).string()
        XCTAssertEqual(titleText, "Restablece el permiso de ubicación para continuar")
        
        let descriptionText = try inspector.find(text: translator.t("geolocation.blocked.description").replacingOccurrences(of: "{{bank}}", with: "Test Bank")).string()
        XCTAssertEqual(descriptionText, "Activar este permiso es necesario para completar el pago en Test Bank.")
        
        let continueButton = try inspector.find(button: translator.t("geolocation.blocked.button.continue"))
        XCTAssertEqual(try continueButton.labelView().text().string(), "Activar permiso de ubicación")
        try continueButton.tap()
        
        let declineButton = try inspector.find(button: translator.t("geolocation.blocked.button.decline"))
        XCTAssertEqual(try declineButton.labelView().text().string(), "Salir")
        try declineButton.tap()
        
        wait(for: [expectationContinue, expectationDecline], timeout: 1.0)
    }
}
