import XCTest
import SwiftUI
@testable import KhipuClientIOS

@available(iOS 15.0, *)
class InactivityModalTests: XCTestCase {
    
    func testModalViewIsPresented() {
        let viewModel = KhipuViewModel()
        let themeManager = ThemeManager()
        
        let getFunction: () -> Bool = { true }
        let setFunction: (Bool) -> Void = { param in }
        
        let view = InactivityModal(isPresented: Binding(get: getFunction, set: setFunction), onDismiss: {}, viewModel: viewModel)
            .environmentObject(themeManager)
        
        let inspectView = try! view.inspect()
        XCTAssertEqual(inspectView.findAll(ModalView.self).count, 1)
    }
    
    func testModalViewIsNotPresented() {
        let viewModel = KhipuViewModel()
        let themeManager = ThemeManager()
        
        let getFunction: () -> Bool = { false }
        let setFunction: (Bool) -> Void = { param in }
        
        let view = InactivityModal(isPresented: Binding(get: getFunction, set: setFunction), onDismiss: {}, viewModel: viewModel)
            .environmentObject(themeManager)
        
        let inspectView = try! view.inspect()
        XCTAssertEqual(inspectView.findAll(ModalView.self).count, 0)
    }
    
    func testPrimaryButtonAction() {
        var onDismissCalled = false
        let viewModel = KhipuViewModel()
        let themeManager = ThemeManager()
        
        let getFunction: () -> Bool = { true }
        let setFunction: (Bool) -> Void = { param in }
        
        let view = InactivityModal(isPresented: Binding(get: getFunction, set: setFunction), onDismiss: { onDismissCalled = true }, viewModel: viewModel)
            .environmentObject(themeManager)
        
        let inspectView = try! view.inspect().view(InactivityModal.self)
        let button = try! inspectView.find(button: "page.are.you.there.continue.button")
        try! button.tap()
        XCTAssertTrue(onDismissCalled)
    }
    
}
