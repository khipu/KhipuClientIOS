import SwiftUI

@available(iOS 14.0, *)
struct ToastComponent: View {
    var text: String
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        HStack(alignment: .center, spacing: Dimens.Spacing.medium) {
            Image(systemName: "wifi.slash")
                .foregroundColor(themeManager.selectedTheme.colors.surface)
                .frame(width: Dimens.Frame.large, height: Dimens.Frame.large)
            VStack(alignment: .leading, spacing: Dimens.Spacing.verySmall) {
                Text(text)
                    .font(themeManager.selectedTheme.fonts.font(style: .regular, size: 14))
                    .foregroundColor(themeManager.selectedTheme.colors.surface)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .padding(.vertical, Dimens.Padding.extraSmall)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .padding(.horizontal, Dimens.Padding.large)
        .padding(.vertical, Dimens.Padding.moderatelySmall)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(themeManager.selectedTheme.colors.onSurface)
        .cornerRadius(4)
    }
}

@available(iOS 14.0, *)
struct ToastComponent_Previews: PreviewProvider {
    static var previews: some View {
        ToastComponent(text: "No tienes conexión a internet")
            .environmentObject(ThemeManager())
    }
}
