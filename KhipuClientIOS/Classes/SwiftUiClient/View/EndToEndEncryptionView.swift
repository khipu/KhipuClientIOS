import SwiftUI

@available(iOS 15.0, *)
struct EndToEndEncryptionView: View {
    var translator: KhipuTranslator
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        VStack {
            CircularProgressView()
                .frame(width:Dimens.Frame.extraLarge,
                       height:Dimens.Frame.extraLarge,
                       alignment: .center)
                .padding([.top],Dimens.Padding.massive)
            Text(translator.t("default.end.to.end.encryption", default: ""))
                .frame(alignment: .center)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
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

