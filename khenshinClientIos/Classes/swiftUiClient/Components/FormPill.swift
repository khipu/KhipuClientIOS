import SwiftUI

@available(iOS 13.0, *)
struct FormPill: View {
    var text: String
    @ObservedObject var themeManager: ThemeManager
    
    var body: some View {
        Text(text)
            .foregroundColor(themeManager.selectedTheme.onSurface)
            .padding(.all, Dimens.extraSmall)
            .overlay(
                RoundedRectangle(cornerRadius: Dimens.large)
                    .stroke(themeManager.selectedTheme.onSurface, lineWidth: 1))
    }
}

@available(iOS 13.0, *)
struct FormPill_Previews: PreviewProvider {
    static var previews: some View {
        FormPill(text: "Nombre banco", themeManager: ThemeManager())
    }
}
