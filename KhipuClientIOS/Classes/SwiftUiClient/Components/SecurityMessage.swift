import SwiftUI

@available(iOS 15.0, *)
struct SecurityMessage: View {
    var translator: KhipuTranslator?
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            if let lockImage = KhipuClientBundleHelper.image(named: "lock-key") {
                Image(uiImage: lockImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
            } else {
                Image(systemName: "lock.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color(hexString: "#9797A5") ?? .gray)
            }

            Text(translator?.t("default.encrypted.data.label") ?? "Datos protegidos por encriptación")
                .font(.custom("Public Sans", size: 12).weight(.regular))
                .foregroundColor(Color(hexString: "#9797A5") ?? .gray)
                .tracking(0.4)
                .lineSpacing(3)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 10)
        .padding(.vertical, 0)
    }
}

@available(iOS 15.0, *)
struct SecurityMessage_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            SecurityMessage(translator: nil)
                .environmentObject(ThemeManager())

            SecurityMessage(translator: MockDataGenerator.createTranslator())
                .environmentObject(ThemeManager())
        }
        .padding()
        .background(Color.white)
    }
}
