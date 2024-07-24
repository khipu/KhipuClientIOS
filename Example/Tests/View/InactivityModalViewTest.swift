import XCTest
import SwiftUI
@testable import KhipuClientIOS

@available(iOS 15.0, *)
class InactivityModalViewTests: XCTestCase {
    
    
    func testModalViewIsPresented() {
        let viewModel = KhipuViewModel()
        let themeManager = ThemeManager()
        
        let getFunction: () -> Bool = { true }
        let setFunction: (Bool) -> Void = { param in }
        
        
        let view = InactivityModalView(isPresented: Binding(get: getFunction, set: setFunction), onDismiss: {},translator: MockDataGenerator.createTranslator())
            .environmentObject(themeManager)
        
        let inspectView = try! view.inspect()
        XCTAssertEqual(inspectView.findAll(ModalView.self).count, 1)
    }
    
    func testModalViewIsNotPresented() {
        let viewModel = KhipuViewModel()
        let themeManager = ThemeManager()
        
        let getFunction: () -> Bool = { false }
        let setFunction: (Bool) -> Void = { param in }
        
        let view = InactivityModalView(isPresented: Binding(get: getFunction, set: setFunction), onDismiss: {}, translator: MockDataGenerator.createTranslator())
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
        
        let view = InactivityModalView(isPresented: Binding(get: getFunction, set: setFunction), onDismiss: { onDismissCalled = true }, translator: MockDataGenerator.createTranslator())
            .environmentObject(themeManager)
        
        let inspectView = try! view.inspect().view(InactivityModalView.self)
        let button = try! inspectView.find(button: MockDataGenerator.createTranslator().t("page.are.you.there.continue.button"))
        try! button.tap()
        XCTAssertTrue(onDismissCalled)
    }
    
}
