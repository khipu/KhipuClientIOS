import SwiftUI

@available(iOS 15.0, *)
struct FormWarning: View {
    var text: String
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
                .frame(width: themeManager.selectedTheme.dimens.medium)
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: themeManager.selectedTheme.dimens.large, height: themeManager.selectedTheme.dimens.large)
                .foregroundColor(themeManager.selectedTheme.colors.tertiary)
            Text(text)
                .padding(.all, themeManager.selectedTheme.dimens.medium)
                .foregroundColor(themeManager.selectedTheme.colors.onTertiary)
                .font(.system(size: 16, weight: .regular))
            Spacer()
        }
        .padding(.all, themeManager.selectedTheme.dimens.verySmall)
        .background(themeManager.selectedTheme.colors.surface)
        .overlay(
            RoundedRectangle(cornerRadius: themeManager.selectedTheme.dimens.extraSmall)
                .stroke(themeManager.selectedTheme.colors.tertiary, lineWidth: 1)
                )
        
    }
}
