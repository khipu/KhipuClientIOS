import XCTest
import ViewInspector
import SwiftUI
import KhenshinProtocol
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class NavigationBarComponentTests: XCTestCase {
    func testNavigationBarWithImageURLRendersCorrectly() throws {
        let themeManager = ThemeManager()
        let viewModel = KhipuViewModel()
        
        let view = NavigationBarComponent(imageUrl: "imageUrl", viewModel: viewModel).environmentObject(themeManager)

        let inspectView = try view.inspect().view(NavigationBarComponent.self)
        
        let asyncImage = try inspectView.find(ViewType.AsyncImage.self)
        XCTAssertEqual(try asyncImage.url(), URL(string: "imageUrl"))
    }
    
    func testNavigationBarWithImageNameRendersCorrectly() throws {
        let themeManager = ThemeManager()
        let viewModel = KhipuViewModel()
        
        let view = NavigationBarComponent(imageName: "imageName", viewModel: viewModel).environmentObject(themeManager)

        let inspectView = try view.inspect().view(NavigationBarComponent.self)
        
        let image = try inspectView.find(ViewType.Image.self)
        XCTAssertEqual(try image.actualImage().name(), "imageName")
    }
    
    func testNavigationBarWithTextRendersCorrectly() throws {
        let themeManager = ThemeManager()
        let viewModel = KhipuViewModel()
        
        let view = NavigationBarComponent(title: "title", viewModel: viewModel).environmentObject(themeManager)

        let inspectView = try view.inspect().view(NavigationBarComponent.self)
        
        let text = try inspectView.find(ViewType.Text.self)
        XCTAssertEqual(try text.string(), "title")
    }
}
