import SwiftUI

@available(iOS 15.0, *)
struct ProgressComponent: View {
    @ObservedObject var viewModel: KhipuViewModel
    @ObservedObject var themeManager: ThemeManager

    var body: some View {
        ProgressView(value: Double(viewModel.uiState.currentProgress))
            .progressViewStyle(LinearProgressViewStyle(tint: themeManager.selectedTheme.primary))
            .background(themeManager.selectedTheme.background)
            .accessibility(identifier: "linearProgressIndicator")
    }
}
