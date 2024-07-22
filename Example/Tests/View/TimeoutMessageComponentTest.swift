import XCTest
import ViewInspector
import SwiftUI
import KhenshinProtocol
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class TimeoutMessageComponentTest: XCTestCase {
    
    /*
    func testTimeoutMessageComponentRendersCorrectly() throws {
        let themeManager = ThemeManager()
        let viewModel = KhipuViewModel()
        
        let operationFailure = OperationFailure(
            type: .operationFailure,
            body: "The operation could not be completed",
            events: nil,
            exitURL: nil,
            operationID: "12345",
            resultMessage: nil,
            title: "Operation Failed",
            reason: .noBackendAvailable
        )
        
        let view = TimeoutMessageComponent(operationFailure: operationFailure, viewModel: viewModel).environmentObject(themeManager)
        
        let inspectView = try view.inspect().view(TimeoutMessageComponent.self)
        
        let texts = inspectView.findAll(ViewType.Text.self)
        let images = inspectView.findAll(ViewType.Image.self)
        let formWarnings = inspectView.findAll(FormWarning.self)
        
        XCTAssertEqual(try texts[0].string(), "page.timeout.session.closed")
        XCTAssertNoThrow(try inspectView.find(text: "page.timeout.session.closed"))
        XCTAssertEqual(formWarnings.count, 1)
        XCTAssertGreaterThanOrEqual(images.count, 1)
        XCTAssertNoThrow(try inspectView.find(text: "page.timeout.end"))
        XCTAssertNoThrow(try inspectView.find(text: "default.operation.code.label"))
        XCTAssertEqual(inspectView.findAll(CopyToClipboardOperationId.self).count, 1)
        XCTAssertNoThrow(try inspectView.find(MainButton.self))

    }
     */
}
