import SwiftUI

@available(iOS 15.0, *)
struct FormInfo: View {
    var text: String
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
            Spacer()
                .frame(width: themeManager.selectedTheme.dimens.small)
            Image(systemName: "info.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .foregroundColor(themeManager.selectedTheme.colors.secondary)
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(themeManager.selectedTheme.colors.secondary)
            Spacer()
        }
        .padding(.all, 10)
        .background(themeManager.selectedTheme.colors.surface)
        .overlay(
            RoundedRectangle(cornerRadius: themeManager.selectedTheme.dimens.extraSmall)
                .stroke(themeManager.selectedTheme.colors.secondary, lineWidth: 0.3)
                )
    }
}

@available(iOS 15.0, *)
struct FormInfo_Previews: PreviewProvider {
    static var previews: some View {
        FormInfo(text: "Info text")
            .environmentObject(ThemeManager())
            .padding()
    }
}
