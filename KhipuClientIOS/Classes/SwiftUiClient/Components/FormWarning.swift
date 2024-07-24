import SwiftUI

@available(iOS 15.0, *)
struct FormWarning: View {
    var text: String
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        
        HStack(alignment: .center) {
            HStack(alignment: .top, spacing: 0) {
                Image(systemName: "exclamationmark.triangle")
                .foregroundColor(themeManager.selectedTheme.colors.warning) }
            .padding(.leading, 0)
            .padding(.trailing,Dimens.Padding.veryMedium)
            .padding(.vertical,Dimens.Padding.extraSmall)
            
            VStack(alignment: .leading, spacing:Dimens.Spacing.verySmall) {
                Text(text)
                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 14))
                    .kerning(0.17)
                    .foregroundColor(themeManager.selectedTheme.colors.warning)
                .frame(maxWidth: .infinity, alignment: .topLeading) }
            .padding(.horizontal, 0)
            .padding(.vertical,Dimens.Padding.extraSmall)
        }
        .padding(.horizontal,Dimens.Padding.extraMedium)
        .padding(.vertical,Dimens.Padding.moderatelySmall)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .cornerRadius(Dimens.CornerRadius.verySmall)
        .overlay(
            RoundedRectangle(cornerRadius:Dimens.CornerRadius.verySmall)
                .inset(by: 0.5)
                .stroke(themeManager.selectedTheme.colors.warning, lineWidth: 1)
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
