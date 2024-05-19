import SwiftUI

@available(iOS 13.0, *)
struct FieldLabel: View {
    var text: String?
    @ObservedObject var themeManager: ThemeManager
    
    var body: some View {
        VStack {
            Text(text ?? "")
                .foregroundColor(themeManager.selectedTheme.onSurface)
                .font(.subheadline)
            Spacer().frame(height: Dimens.extraSmall)
        }
    }
}
