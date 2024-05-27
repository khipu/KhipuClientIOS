import SwiftUI

@available(iOS 13.0, *)
struct FormPill: View {
    var text: String
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Text(text)
            .foregroundColor(themeManager.selectedTheme.colors.onSurface)
            .padding(.all, themeManager.selectedTheme.dimens.extraSmall)
            .overlay(
                RoundedRectangle(cornerRadius: themeManager.selectedTheme.dimens.large)
                    .stroke(themeManager.selectedTheme.colors.onSurface, lineWidth: 1))
    }
}

@available(iOS 13.0, *)
struct FormPill_Previews: PreviewProvider {
    static var previews: some View {
        FormPill(text: "Nombre banco")
    }
}
