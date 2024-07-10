import XCTest
import SwiftUI
import ViewInspector
import KhenshinProtocol
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class WarningMessageComponentTest: XCTestCase {
   
    
    
    func testWarningMessageComponentRendersCorrectly() throws {
        let themeManager = ThemeManager()
        let viewModel = KhipuViewModel()
        let operationWarning = OperationWarning(
            type: .operationWarning,
            body: "The operation could not be completed",
            events: nil,
            exitURL: nil,
            operationID: "12345",
            resultMessage: nil,
            title: "Operation Warning",
            reason: .taskDumped
        )
        
        let view = WarningMessageComponent(operationWarning: operationWarning, viewModel: viewModel)
            .environmentObject(themeManager)
        
        let inspectedView = try view.inspect().view(WarningMessageComponent.self)
        XCTAssertNotNil(try? inspectedView.find(text: "Operation Warning"), "Failed to find the text: Operation Warning")
    }
    
}
