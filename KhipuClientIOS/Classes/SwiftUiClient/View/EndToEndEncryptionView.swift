import SwiftUI

@available(iOS 15.0, *)
struct EndToEndEncryptionView: View {
    var translator: KhipuTranslator
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        VStack {
            VStack(alignment: .center) {
                CircularProgressView()
                    .frame(width: Dimens.Frame.extraLarge,
                           height:Dimens.Frame.extraLarge,
                           alignment: .center)
                    .padding(.top,Dimens.Padding.massive)
                Spacer().frame(height: 30)
                Text(translator.t("default.end.to.end.encryption", default: ""))
                    .font(themeManager.selectedTheme.fonts.font(style: .medium, size: 14))
                    .padding(.horizontal,Dimens.Padding.moderatelyLarge)
                    .foregroundStyle(themeManager.selectedTheme.colors.onSurfaceVariant)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal,Dimens.Padding.moderatelyLarge)
    }
}

@available(iOS 15.0, *)
struct EndToEndEncryptionView_Previews: PreviewProvider {
    static var previews: some View {
        return EndToEndEncryptionView(translator: MockDataGenerator.createTranslator())
            .environmentObject(ThemeManager())
            .padding()
    }
}

