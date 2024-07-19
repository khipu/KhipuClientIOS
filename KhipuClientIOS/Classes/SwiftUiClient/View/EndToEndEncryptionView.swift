import SwiftUI

@available(iOS 13.0, *)
struct EndToEndEncryption: View {
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

/*
@available(iOS 13.0, *)
struct EndToEndEncryption_Previews: PreviewProvider {
    static var previews: some View {
        EndToEndEncryption(viewModel: KhipuViewModel())
            .environmentObject(ThemeManager())
            .padding()
    }
}
*/
