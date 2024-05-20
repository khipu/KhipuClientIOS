import SwiftUI

@available(iOS 15.0, *)
struct FormInfo: View {
    var text: String
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
            Spacer()
                .frame(width: themeManager.selectedTheme.dimens.medium)
            Image(systemName: "info.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(themeManager.selectedTheme.colors.secondary)
            Text(text)
                .font(.system(size: 16))
                .foregroundColor(themeManager.selectedTheme.colors.secondary)
            Spacer()
        }
        .padding(.all, themeManager.selectedTheme.dimens.verySmall)
        .background(themeManager.selectedTheme.colors.surface)
        .overlay(
            RoundedRectangle(cornerRadius: themeManager.selectedTheme.dimens.extraSmall)
                .stroke(themeManager.selectedTheme.colors.secondary, lineWidth: 1)
                )
    }
}

