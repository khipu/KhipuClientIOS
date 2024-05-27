import SwiftUI

@available(iOS 13.0, *)
struct HintLabel: View {
    var text: String?
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            Spacer()
            Text(text ?? "")
                .font(.caption)
                .foregroundColor(themeManager.selectedTheme.colors.onSurface)
            }
    }
}
