import SwiftUI

@available(iOS 15.0, *)
struct FieldLabel: View {
    var text: String?
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack {
            Text(text ?? "")
                .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                .font(.subheadline)
                .accessibilityIdentifier("labelText")
            Spacer().frame(height: themeManager.selectedTheme.dimens.extraSmall)
        }
    }
}

@available(iOS 15.0, *)
struct FieldLabel_Previews: PreviewProvider {
    static var previews: some View {
        return FieldLabel(text: "Field label")
            .environmentObject(ThemeManager())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
