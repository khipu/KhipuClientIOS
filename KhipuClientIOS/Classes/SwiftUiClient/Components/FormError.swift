import SwiftUI

@available(iOS 15.0, *)
struct FormError: View {
    var text: String?
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        if !(text?.isEmpty ?? true) {
            HStack {
                Text(text ?? "")
                    .font(.caption2)
                    .foregroundColor(themeManager.selectedTheme.colors.onErrorContainer)
                    .padding(.all, themeManager.selectedTheme.dimens.extraSmall)
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .background(
                RoundedRectangle(cornerRadius: themeManager.selectedTheme.dimens.extraSmall)
                    .foregroundColor(  themeManager.selectedTheme.colors.errorContainer)
                
            )
            .overlay(
                RoundedRectangle(cornerRadius: themeManager.selectedTheme.dimens.extraSmall)
                    .stroke(themeManager.selectedTheme.colors.onBackground, lineWidth: 0.5)
            )
        }
    }
}

@available(iOS 15.0, *)
struct FormError_Previews: PreviewProvider {
    static var previews: some View {
        FormError(text: "Some error has ocurred").environmentObject(ThemeManager())
    }
}


@available(iOS 15.0, *)
struct FormErrorEmpty_Previews: PreviewProvider {
    static var previews: some View {
        FormError().environmentObject(ThemeManager())
    }
}
