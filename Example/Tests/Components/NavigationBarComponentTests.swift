import XCTest
import ViewInspector
import SwiftUI
import KhenshinProtocol
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class NavigationBarComponentTests: XCTestCase {
    func testNavigationBarRendersCorrectly() throws {
        let themeManager = ThemeManager()
        let viewModel = KhipuViewModel()
        
        let viewImageUrl = NavigationBarComponent(imageUrl: "imageUrl", viewModel: viewModel).environmentObject(themeManager)
        let viewImageName = NavigationBarComponent(imageName: "imageName", viewModel: viewModel).environmentObject(themeManager)
        let viewTitle = NavigationBarComponent(title: "title", viewModel: viewModel).environmentObject(themeManager)
        let viewEmpty = NavigationBarComponent(viewModel: viewModel).environmentObject(themeManager)
        
        ViewHosting.host(view: viewImageUrl)
        ViewHosting.host(view: viewImageName)
        ViewHosting.host(view: viewTitle)
        ViewHosting.host(view: viewEmpty)
        
        let exp = expectation(description: "onAppear")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exp.fulfill()
            do {
                var inspectView = try viewImageUrl.inspect().view(NavigationBarComponent.self)
                var hStack = try inspectView.hStack()
                
                XCTAssertNoThrow(try hStack.asyncImage(2))
                XCTAssertThrowsError(try hStack.image(2))
                XCTAssertThrowsError(try hStack.text(2))
                XCTAssertNoThrow(try hStack.button(4))
                
                inspectView = try viewImageName.inspect().view(NavigationBarComponent.self)
                hStack = try inspectView.hStack()
                
                XCTAssertNoThrow(try hStack.image(2))
                XCTAssertThrowsError(try hStack.asyncImage(2))
                XCTAssertThrowsError(try hStack.text(2))
                XCTAssertNoThrow(try hStack.button(4))
                
                inspectView = try viewTitle.inspect().view(NavigationBarComponent.self)
                hStack = try inspectView.hStack()
                
                XCTAssertNoThrow(try hStack.text(2))
                XCTAssertThrowsError(try hStack.asyncImage(2))
                XCTAssertThrowsError(try hStack.image(2))
                XCTAssertNoThrow(try hStack.button(4))
            } catch {
                XCTFail("Failed to inspect view: \(error)")
            }
        }
        wait(for: [exp], timeout: 2.0)
    }
}
