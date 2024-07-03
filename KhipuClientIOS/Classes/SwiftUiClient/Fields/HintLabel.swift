import SwiftUI

@available(iOS 15.0, *)
struct HintLabel: View {
    var text: String?
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        if !(text?.isEmpty ?? true) {
            HStack {
                Text(text ?? "")
                    .font(themeManager.selectedTheme.fonts.font(style: .regular, size: 12))
                    .foregroundColor(themeManager.selectedTheme.colors.labelForeground)
                    .accessibilityIdentifier("hintText")
                Spacer()
            }
            .padding(.top, themeManager.selectedTheme.dimens.verySmall)
        }
    }
}

@available(iOS 15.0, *)
struct HintLabel_Previews: PreviewProvider {
    static var previews: some View {
        return HintLabel(text: "This is a hint label")
            .environmentObject(ThemeManager())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
