import SwiftUI

@available(iOS 15.0, *)
struct FooterComponent: View {
    var translator: KhipuTranslator
    var showFooter: Bool
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        if showFooter{
            HStack(alignment: .center, spacing: Dimens.Spacing.small) {
                
                Text(translator.t("footer.powered.by"))
                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 12))
                    .foregroundColor(themeManager.selectedTheme.colors.onSurfaceVariant)
                
                AsyncImage(url: URL(string: "https://s3.amazonaws.com/static.khipu.com/icon/logo-khipu-color.png")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: Dimens.Frame.almostLarge, height: Dimens.Frame.moderatelyMedium)
                        .clipped()
                } placeholder: {
                    ProgressView()
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}


@available(iOS 15.0, *)
struct FooterComponent_Previews: PreviewProvider {
    static var previews: some View {
        FooterComponent(translator: MockDataGenerator.createTranslator(), showFooter: true)
            .environmentObject(ThemeManager())
    }
}

