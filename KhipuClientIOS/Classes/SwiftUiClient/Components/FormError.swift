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
                        .foregroundColor(.red)
                        .frame(width:Dimens.Frame.large, height:Dimens.Frame.large)
                }
                .padding(.leading, 0)
                .padding(.trailing,Dimens.Padding.veryMedium)
                .padding(.vertical,Dimens.Padding.extraSmall)
                
                
                VStack(alignment: .leading, spacing:Dimens.Spacing.verySmall) {
                    
                    Text(text!)
                        .font(themeManager.selectedTheme.fonts.font(style: .regular, size:14))
                        .kerning(0.17)
                        .foregroundColor(themeManager.selectedTheme.colors.onTertiary)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 0)
                .padding(.vertical,Dimens.Padding.extraSmall)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                
                
            }
            .padding(.horizontal,Dimens.Padding.extraMedium)
            .padding(.vertical,Dimens.Padding.moderatelySmall)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .cornerRadius(Dimens.CornerRadius.verySmall)
            .overlay(
                RoundedRectangle(cornerRadius:Dimens.CornerRadius.verySmall)
                    .inset(by: 0.5)
                    .stroke(.red, lineWidth: 1)
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
