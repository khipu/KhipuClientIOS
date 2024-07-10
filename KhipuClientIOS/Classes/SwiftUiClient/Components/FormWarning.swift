import SwiftUI

@available(iOS 15.0, *)
struct FormWarning: View {
    var text: String
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        
        HStack(alignment: .center) {
            HStack(alignment: .top, spacing: 0) {
                Image(systemName: "exclamationmark.triangle")
                .foregroundColor(themeManager.selectedTheme.colors.tertiaryContainer) }
            .padding(.leading, 0)
            .padding(.trailing,Dimens.Padding.veryMedium)
            .padding(.vertical,Dimens.Padding.extraSmall)
            
            VStack(alignment: .leading, spacing:Dimens.Spacing.verySmall) {
                Text(text)
                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 14))
                    .kerning(0.17)
                    .foregroundColor(themeManager.selectedTheme.colors.onTertiaryContainer)
                .frame(maxWidth: .infinity, alignment: .topLeading) }
            .padding(.horizontal, 0)
            .padding(.vertical,Dimens.Padding.extraSmall)
        }
        .padding(.horizontal,Dimens.Padding.large)
        .padding(.vertical,Dimens.Padding.moderatelySmall)
        .overlay(
            Rectangle()
                .inset(by: 0.5)
                .stroke(themeManager.selectedTheme.colors.tertiaryContainer, lineWidth: 1)
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
