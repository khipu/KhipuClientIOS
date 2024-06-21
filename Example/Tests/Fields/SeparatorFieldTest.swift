import XCTest
import SwiftUI
import ViewInspector
import KhenshinProtocol

@testable import KhipuClientIOS

@available(iOS 15.0.0, *)
final class SeparatorFieldTest: XCTestCase {
    
    func testSeparatorFieldView() throws {
        let formItem = try! FormItem(
                     """
                         {
                           "id": "item1",
                           "type": "\(FormItemTypes.separator.rawValue)",
                           "color": "#00ff00"
                         }
                     """
        )
        
        let view = SeparatorField(formItem: formItem)
        
        let inspected = try view.environmentObject(ThemeManager()).inspect()
        
        XCTAssertNoThrow(try inspected
            .view(SeparatorField.self)
            .shape(0))
        
    }

}
