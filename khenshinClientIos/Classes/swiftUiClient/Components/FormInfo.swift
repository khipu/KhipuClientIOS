import SwiftUI

@available(iOS 15.0, *)
struct FormInfo: View {
    var text: String
    @ObservedObject var themeManager: ThemeManager

    var body: some View {
        HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
            Spacer()
                .frame(width: Dimens.medium)
            Image(systemName: "info.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(themeManager.selectedTheme.secondary)
            Text(text)
                .font(.system(size: 16))
                .foregroundColor(themeManager.selectedTheme.secondary)
            Spacer()
        }
        .padding(.all, Dimens.verySmall)
        .background(themeManager.selectedTheme.surface)
        .overlay(
            RoundedRectangle(cornerRadius: Dimens.extraSmall)
                .stroke(themeManager.selectedTheme.secondary, lineWidth: 1)
                )
    }
}

