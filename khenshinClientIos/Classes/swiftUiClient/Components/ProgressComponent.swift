import SwiftUI

@available(iOS 15.0, *)
struct ProgressComponent: View {
    @ObservedObject var khenshinViewModel: KhenshinViewModel
    @ObservedObject var themeManager: ThemeManager

    var body: some View {
        ProgressView(value: Double(khenshinViewModel.uiState.currentProgress))
            .progressViewStyle(LinearProgressViewStyle(tint: themeManager.selectedTheme.primary))
            .background(themeManager.selectedTheme.background)
            .accessibility(identifier: "linearProgressIndicator")
    }
}
