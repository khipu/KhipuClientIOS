import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS

@available(iOS 15.0,*)
final class ProgressComponentTest: XCTestCase {
    /*
    func testProgressComponentRendersCorrectly() throws {
        let themeManager = ThemeManager()
        let viewModel = KhipuViewModel()
        viewModel.uiState.currentProgress = 0.5
        let view = ProgressComponent(viewModel: viewModel).environmentObject(themeManager)

        let inspectedView = try view.inspect().view(ProgressComponent.self)
        let progressView = try inspectedView.progressView()
        XCTAssertEqual(
            try progressView.tint(),
            themeManager.selectedTheme.colors.primary,
            "Tint color is incorrect"
        )
        XCTAssertEqual(
            try progressView.accessibilityIdentifier(),
            "linearProgressIndicator",
            "Accessibility identifier is incorrect"
        )
    }
     */
}
