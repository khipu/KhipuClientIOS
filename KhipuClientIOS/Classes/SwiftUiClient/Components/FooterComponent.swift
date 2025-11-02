import SwiftUI

@available(iOS 15.0, *)
struct FooterComponent: View {
    var translator: KhipuTranslator
    var showFooter: Bool
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        if showFooter{
            HStack(alignment: .center, spacing: Dimens.Spacing.verySmall) {
                
                Text(translator.t("footer.powered.by"))
                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 12))
                    .foregroundColor(themeManager.selectedTheme.colors.onSurfaceVariant)
               
                if let uiImage = KhipuClientBundleHelper.image(named: "logo-khipu-color") {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: Dimens.Frame.almostLarge, height: Dimens.Frame.moderatelyMedium)
                        .clipped()
                }
               
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        HStack(alignment: .center) {
            Text("v" + KhipuVersion.version)
                .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 10))
                .foregroundColor(themeManager.selectedTheme.colors.onSurfaceVariant)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}


@available(iOS 15.0, *)
struct FooterComponent_Previews: PreviewProvider {
    static var previews: some View {
        FooterComponent(translator: MockDataGenerator.createTranslator(), showFooter: true)
            .environmentObject(ThemeManager())
    }
}

