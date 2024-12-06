import XCTest
import SwiftUI
import ViewInspector
import KhenshinProtocol

@testable import KhipuClientIOS

@available(iOS 15.0.0, *)
final class SeparatorFieldTest: XCTestCase {
    
    func testSeparatorFieldView() throws {

        let view = SeparatorField(formItem: MockDataGenerator.createSeparatorFormItem())
        
        let inspected = try view.environmentObject(ThemeManager()).inspect()
        
        XCTAssertNoThrow(try inspected
            .view(SeparatorField.self)
            .implicitAnyView()
            .shape(0))
        
    }

}
