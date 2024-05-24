import XCTest
@testable import khenshinClientIos
import SwiftUI
import ViewInspector


@available(iOS 13.0, *)
class ViewInspectorUtils {

    static func verifyFormTitleInVStack(_ vStack: InspectableView<ViewInspector.ViewType.VStack>, expectedText: String) throws -> Bool {
        for index in 0..<vStack.count {
            if let formTitle = try? vStack.view(FormTitle.self, index) {
                let text = try formTitle.text().string()
                if text == expectedText {
                    XCTAssertEqual(text, expectedText)
                    return true
                }
            }
        }
        return false
    }

    static func verifyTextInVStack(_ vStack: InspectableView<ViewInspector.ViewType.VStack>, expectedText: String) throws -> Bool {
        for index in 0..<vStack.count {
            if let text = try? vStack.text(index).string() {
                if text == expectedText {
                    XCTAssertEqual(text, expectedText)
                    return true
                }
            }
            if let innerVStack = try? vStack.vStack(index) {
                if try verifyTextInVStack(innerVStack, expectedText: expectedText) {
                    return true
                }
            }
        }
        return false
    }

    static func verifyButtonInVStack(_ vStack: InspectableView<ViewInspector.ViewType.VStack>, expectedButtonText: String) throws -> Bool {
        for index in 0..<vStack.count {
            if let button = try? vStack.button(index) {
                let buttonText = try button.labelView().text().string()
                if buttonText == expectedButtonText {
                    XCTAssertEqual(buttonText, expectedButtonText)
                    XCTAssertTrue(try button.isDisabled())
                    return true
                }
            }
            if let innerVStack = try? vStack.vStack(index) {
                if try verifyButtonInVStack(innerVStack, expectedButtonText: expectedButtonText) {
                    return true
                }
            }
        }
        return false
    }
}
