import XCTest
@testable import KhipuClientIOS
import SwiftUI
import ViewInspector
@testable import KhenshinProtocol

@available(iOS 15.0, *)
final class AuthorizationRequestViewTests: XCTestCase {

    func testAuthorizationRequestViewRendersMobileAuthorizationRequestView() throws {
        let translator = MockDataGenerator.createTranslator()
        let view = AuthorizationRequestView(
            authorizationRequest: MockDataGenerator.createAuthorizationRequest(authorizationType:.mobile, message: "Please authorize using the app"),
            translator: translator,
            bank: "Banco"
        )
        .environmentObject(ThemeManager())

        let inspectedView = try view.inspect()
            .view(AuthorizationRequestView.self)
            .view(MobileAuthorizationRequestView.self)

        XCTAssertNotNil(try? inspectedView.find(text: translator.t("Please authorize using the app")), "Failed to find the text: Please authorize using the app")
        XCTAssertNotNil(try? inspectedView.find(text: translator.t("Esperando autorización")), "Failed to find the text: Esperando autorización")
    }


    @available(iOS 15.0, *)
    func testAuthorizationRequestViewRendersQrAuthorizationRequestView() throws {
        let view = AuthorizationRequestView(
            authorizationRequest: MockDataGenerator.createAuthorizationRequest(authorizationType:.qr, message: "Scan the QR code"),
            translator: MockDataGenerator.createTranslator(),
            bank: ""
        )
        .environmentObject(ThemeManager())

        let inspectedView = try view.inspect()
            .view(AuthorizationRequestView.self)
            .view(QrAuthorizationRequestView.self)

        XCTAssertNotNil(try? inspectedView.find(text: "Scan the QR code"), "Failed to find the text: Scan the QR code")
    }
}
