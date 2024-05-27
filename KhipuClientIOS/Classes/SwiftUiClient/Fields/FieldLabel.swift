import SwiftUI

@available(iOS 13.0, *)
struct FieldLabel: View {
    var text: String?
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack {
            Text(text ?? "")
                .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                .font(.subheadline)
            Spacer().frame(height: themeManager.selectedTheme.dimens.extraSmall)
        }
    }
}
