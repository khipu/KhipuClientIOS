import SwiftUI

@available(iOS 15.0, *)
struct FieldLabel: View {
    var text: String?
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        if !(text?.isEmpty ?? true) {
            VStack {
                Text(text ?? "")
                    .font(themeManager.selectedTheme.fonts.regular14)
                    .accessibilityIdentifier("labelText")
                    .lineSpacing(themeManager.selectedTheme.dimens.medium)
                    .padding(.bottom, themeManager.selectedTheme.dimens.extraSmall)
            }
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
