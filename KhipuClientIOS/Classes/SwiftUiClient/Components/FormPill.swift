import SwiftUI

@available(iOS 15.0, *)
struct FormPill: View {
    var text: String
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack(alignment: .center, spacing: themeManager.selectedTheme.dimens.moderatelySmall) {
            Text(text)
                .font(themeManager.selectedTheme.fonts.font(style: .medium, size: 14))
                .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                .frame(width: 89,height: 32)
            
        }
        .padding(.horizontal, themeManager.selectedTheme.dimens.veryMedium)
        .cornerRadius(themeManager.selectedTheme.dimens.large)
        .overlay(
            RoundedRectangle(cornerRadius: themeManager.selectedTheme.dimens.large)
                .stroke(themeManager.selectedTheme.colors.onSurface, lineWidth:0.5)
            
        )
    }
}

@available(iOS 15.0, *)
struct FormPill_Previews: PreviewProvider {
    static var previews: some View {
        FormPill(text: "Bank name")
            .environmentObject(ThemeManager())
    }
}
