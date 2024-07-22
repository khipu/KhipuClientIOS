import XCTest
import SwiftUI
import ViewInspector
import KhenshinProtocol
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class MustContinueViewTest: XCTestCase {
    
    func testMustContinueComponentRendersCorrectly() throws {
        let themeManager = ThemeManager()

        let view = MustContinueView(operationMustContinue: MockDataGenerator.createOperationMustContinue(), translator: MockDataGenerator.createTranslator(), operationInfo: MockDataGenerator.createOperationInfo(), returnToApp:{})
            .environmentObject(themeManager)
        
        let inspectedView = try view.inspect().view(MustContinueView.self)
        
        XCTAssertNotNil(try? inspectedView.find(text: MockDataGenerator.createTranslator().t("page.operationFailure.header.text.operation.task.finished")), "Failed to find the text: Pago en verificación")
        XCTAssertNotNil(try? inspectedView.find(text: MockDataGenerator.createTranslator().t("default.end.and.go.back")), "Failed to find the text: Pago en verificación")
        XCTAssertNoThrow(try inspectedView.find(MainButton.self))
    }
    
    func testInformationSectionRendersCorrectly() throws {
        let themeManager = ThemeManager()
        
        let view = InformationSection(translator: MockDataGenerator.createTranslator(), operationInfo: MockDataGenerator.createOperationInfo()).environmentObject(themeManager)
        
        let inspectedView = try view.inspect().view(InformationSection.self)
        XCTAssertNotNil(try? inspectedView.find(text: MockDataGenerator.createTranslator().t("page.operationMustContinue.share.description")), "Failed to find the text: page.operationMustContinue.share.description")

        XCTAssertNoThrow(try inspectedView.find(CopyToClipboardLink.self))
    }
}
