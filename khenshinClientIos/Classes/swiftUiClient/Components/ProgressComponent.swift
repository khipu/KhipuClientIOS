import SwiftUI

@available(iOS 15.0, *)
struct ProgressComponent: View {
    @ObservedObject var viewModel: KhipuViewModel
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        ProgressView(value: Double(viewModel.uiState.currentProgress))
            .progressViewStyle(.linear)
            .tint(themeManager.selectedTheme.colors.primary)
            .background(themeManager.selectedTheme.colors.surface)
            .accessibility(identifier: "linearProgressIndicator")
            .padding(.all, 0)
    }
}
