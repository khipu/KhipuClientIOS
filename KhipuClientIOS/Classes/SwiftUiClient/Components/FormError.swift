import SwiftUI

@available(iOS 15.0, *)
struct FormError: View {
    var text: String?
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        
        if !(text?.isEmpty ?? true) {
            HStack(alignment: .top, spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    Image(systemName: "exclamationmark.octagon.fill")
                        .foregroundColor(themeManager.selectedTheme.colors.error)
                        .frame(width: themeManager.selectedTheme.dimens.moderatelyLarge, height: themeManager.selectedTheme.dimens.moderatelyLarge)
                }
                .padding(.leading, 0)
                .padding(.trailing, themeManager.selectedTheme.dimens.veryMedium)
                .padding(.vertical, themeManager.selectedTheme.dimens.extraSmall)
                
                
                VStack(alignment: .leading, spacing: themeManager.selectedTheme.dimens.verySmall) {
                    
                    Text(text!)
                        .font(themeManager.selectedTheme.fonts.font(style: .regular, size:14))
                        .kerning(0.17)
                        .foregroundColor(themeManager.selectedTheme.colors.onTertiary)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 0)
                .padding(.vertical, themeManager.selectedTheme.dimens.extraSmall)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                
                
            }
            .padding(.horizontal, themeManager.selectedTheme.dimens.extraMedium)
            .padding(.vertical, themeManager.selectedTheme.dimens.moderatelySmall)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .cornerRadius(themeManager.selectedTheme.dimens.verySmall)
            .overlay(
                RoundedRectangle(cornerRadius: themeManager.selectedTheme.dimens.verySmall)
                    .inset(by: 0.5)
                    .stroke(themeManager.selectedTheme.colors.error, lineWidth: 1)
            )
        }}
}

@available(iOS 15.0, *)
struct FormError_Previews: PreviewProvider {
    static var previews: some View {
        FormError(text: "La clave que ingresaste es incorrecta. Ingrésala nuevamente").environmentObject(ThemeManager())
    }
}


@available(iOS 15.0, *)
struct FormErrorEmpty_Previews: PreviewProvider {
    static var previews: some View {
        FormError().environmentObject(ThemeManager())
    }
}
