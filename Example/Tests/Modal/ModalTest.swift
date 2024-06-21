import XCTest
import SwiftUI
@testable import KhipuClientIOS

@available(iOS 15.0, *)
class ModalViewTests: XCTestCase {
    func testModalViewFull() {
        let primaryButtonAction = {}
        let secondaryButtonAction = {}
        let modalView = ModalView(
            title: "Title",
            message: "Message",
            primaryButtonLabel: "Primary Button",
            primaryButtonAction: primaryButtonAction,
            primaryButtonColor: .blue,
            secondaryButtonLabel: "Secondary Button",
            secondaryButtonAction: secondaryButtonAction,
            secondaryButtonColor: .white,
            icon: Image(systemName: "icon"),
            iconColor: .red,
            imageSrc: "imageURL",
            countDown: 10)
        
        XCTAssertNotNil(modalView)
        XCTAssertEqual(modalView.title, "Title")
        XCTAssertEqual(modalView.message, "Message")
        XCTAssertEqual(modalView.primaryButtonLabel, "Primary Button")
        XCTAssertNoThrow(modalView.primaryButtonAction)
        XCTAssertEqual(modalView.primaryButtonColor, .blue)
        XCTAssertEqual(modalView.secondaryButtonLabel, "Secondary Button")
        XCTAssertNoThrow(modalView.secondaryButtonAction)
        XCTAssertEqual(modalView.secondaryButtonColor, .white)
        XCTAssertEqual(modalView.icon, Image(systemName: "icon"))
        XCTAssertEqual(modalView.iconColor, .red)
        XCTAssertEqual(modalView.imageSrc, "imageURL")
        XCTAssertEqual(modalView.countDown, 10)
    }
    
    func testModalViewEmpty() {
        let primaryButtonAction = {}
        let modalView = ModalView(
            title: nil,
            message: nil,
            primaryButtonLabel: "Primary Button",
            primaryButtonAction: primaryButtonAction,
            primaryButtonColor: nil,
            secondaryButtonLabel: nil,
            secondaryButtonAction: nil,
            secondaryButtonColor: nil,
            icon: nil,
            iconColor: nil,
            imageSrc: nil,
            countDown: nil)
        
        XCTAssertNotNil(modalView)
        XCTAssertNil(modalView.title)
        XCTAssertNil(modalView.message)
        XCTAssertEqual(modalView.primaryButtonLabel, "Primary Button")
        XCTAssertNoThrow(modalView.primaryButtonAction)
        XCTAssertNil(modalView.primaryButtonColor)
        XCTAssertNil(modalView.secondaryButtonLabel)
        XCTAssertNil(modalView.secondaryButtonAction)
        XCTAssertNil(modalView.secondaryButtonColor)
        XCTAssertNil(modalView.icon)
        XCTAssertNil(modalView.iconColor)
        XCTAssertNil(modalView.imageSrc)
        XCTAssertNil(modalView.countDown)
    }
}

class CountdownTimerViewTests: XCTestCase {
    func testTimeString() {
        let timerView = CountdownTimerView(time: 120)
        XCTAssertEqual(timerView.timeString(time: 120), "02:00")
    }
}

class TimerViewTests: XCTestCase {
    func testTimerViewInitialization() {
        let timerView = TimerView(time: 60)
        XCTAssertEqual(timerView.time, 60)
    }
}
