import XCTest
@testable import KhipuClientIOS
import SwiftUI
import ViewInspector
@testable import KhenshinProtocol

@available(iOS 15.0.0, *)
extension AuthorizationRequestView: Inspectable { }

@available(iOS 15.0.0, *)
extension MobileAuthorizationRequestView: Inspectable { }

@available(iOS 15.0.0, *)
extension QrAuthorizationRequestView: Inspectable { }


@available(iOS 15.0, *)
final class AuthorizationRequestComponentTests: XCTestCase {
    
    func testAuthorizationRequestViewRendersMobileAuthorizationRequestView() throws {
        let themeManager = ThemeManager()
        let viewModel = MockKhipuViewModel()
        viewModel.uiState.currentAuthorizationRequest = AuthorizationRequest(authorizationType: .mobile, imageData: nil, message: "Please authorize using the app", type: .authorizationRequest)
        
        let view = AuthorizationRequestView(viewModel: viewModel)
            .environmentObject(themeManager)
        
        ViewHosting.host(view: view)
        
        let exp = expectation(description: "onAppear")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exp.fulfill()
            do {
                let inspectedView = try view.inspect().view(AuthorizationRequestView.self).view(MobileAuthorizationRequestView.self)
                let vStack = try inspectedView.vStack()
                
                XCTAssertTrue(try ViewInspectorUtils.verifyFormTitleInStack(vStack, expectedText: "Autoriza con tu App"), "Failed to find FormTitle with text: Autoriza con tu App")
                
                XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(vStack, expectedText: "Please authorize using the app"), "Failed to find the text: Please authorize using the app")
                
                XCTAssertTrue(try ViewInspectorUtils.verifyButtonInStack(vStack, expectedButtonText: "Esperando autorización"), "Failed to find the button with text: Esperando autorización")
            } catch {
                XCTFail("Failed to inspect view: \(error)")
            }
        }
        
        wait(for: [exp], timeout: 2.0)
    }
    
    
    @available(iOS 15.0, *)
    func testAuthorizationRequestViewRendersQrAuthorizationRequestView() throws {
        let themeManager = ThemeManager()
        
        let viewModel = MockKhipuViewModel()
        let imageData = "data:image/png;base64," + Data([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x10, 0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0xF3, 0xFF, 0x61, 0x00, 0x00, 0x00, 0x04, 0x67, 0x41, 0x4D, 0x41, 0x00, 0x00, 0xB1, 0x8F, 0x0B, 0xFC, 0x61, 0x05, 0x00, 0x00, 0x00, 0x09, 0x70, 0x48, 0x59, 0x73, 0x00, 0x00, 0x0D, 0xD7, 0x00, 0x00, 0x0D, 0xD7, 0x01, 0x42, 0x28, 0x9B, 0x78, 0x00, 0x00, 0x00, 0x07, 0x74, 0x49, 0x4D, 0x45, 0x07, 0xE3, 0x09, 0x0B, 0x17, 0x11, 0x1A, 0x5C, 0xDD, 0x13, 0x70, 0x00, 0x00, 0x00, 0x0B, 0x49, 0x44, 0x41, 0x54, 0x08, 0x99, 0x63, 0x60, 0x18, 0x05, 0xA3, 0x60, 0x14, 0x8C, 0xE8, 0xD5, 0x7F, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82]).base64EncodedString()
        viewModel.uiState.currentAuthorizationRequest = AuthorizationRequest(authorizationType: .qr, imageData: imageData, message: "Scan the QR code", type: .authorizationRequest)
        
        let view = AuthorizationRequestView(viewModel: viewModel)
            .environmentObject(themeManager)
        
        ViewHosting.host(view: view)
        let exp = expectation(description: "onAppear")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exp.fulfill()
            do {
                let inspectedView = try view.inspect().view(AuthorizationRequestView.self).view(QrAuthorizationRequestView.self)
                
                let vStack = try inspectedView.vStack()
                XCTAssertTrue(try ViewInspectorUtils.verifyTextInStack(vStack, expectedText: "Scan the QR code"), "Scan the QR code")
                
            } catch {
                XCTFail("Failed to inspect view: \(error)")
            }
        }
        
        wait(for: [exp], timeout: 2.0)
    }
}
