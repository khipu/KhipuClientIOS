import SwiftUI

@available(iOS 15.0, *)
struct ProgressComponent: View {
    @ObservedObject var viewModel: KhipuViewModel
    @ObservedObject var themeManager: ThemeManager

    var body: some View {
        ProgressView(value: Double(viewModel.uiState.currentProgress))
            .progressViewStyle(.linear)
            .tint(themeManager.selectedTheme.primary)
            .background(themeManager.selectedTheme.surface)
            .accessibility(identifier: "linearProgressIndicator")
            .padding(.all, 0)
    }
}
