import SwiftUI

@available(iOS 15.0, *)
struct FormWarning: View {
    var text: String
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        
        HStack(alignment: .center) {
            HStack(alignment: .top, spacing: 0) {
                Image(systemName: "exclamationmark.triangle")
                .foregroundColor(themeManager.selectedTheme.colors.tertiary) }
            .padding(.leading, 0)
            .padding(.trailing, themeManager.selectedTheme.dimens.veryMedium)
            .padding(.vertical, themeManager.selectedTheme.dimens.extraSmall)
            
            VStack(alignment: .leading, spacing: themeManager.selectedTheme.dimens.verySmall) {
                Text(text)
                    .font(themeManager.selectedTheme.fonts.semiBold14)
                    .kerning(0.17)
                    .foregroundColor(themeManager.selectedTheme.colors.onTertiary)
                .frame(maxWidth: .infinity, alignment: .topLeading) }
            .padding(.horizontal, 0)
            .padding(.vertical, themeManager.selectedTheme.dimens.extraSmall)
        }
        .padding(.horizontal, themeManager.selectedTheme.dimens.large)
        .padding(.vertical, themeManager.selectedTheme.dimens.moderatelySmall)
        .overlay(
            Rectangle()
                .inset(by: 0.5)
                .stroke(themeManager.selectedTheme.colors.tertiary, lineWidth: 1)
        )
    }
}

@available(iOS 15.0, *)
struct FormWarning_Previews: PreviewProvider{
    static var previews: some View {
        FormWarning(text: "Warning text")
            .environmentObject(ThemeManager())
            .padding()
    }
}
