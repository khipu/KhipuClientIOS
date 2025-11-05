import SwiftUI

@available(iOS 15.0, *)
struct FormIconHeader: View {
    var iconName: String
    var title: String
    var subtitle: String
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hexString: "#F0F0FA") ?? Color.purple.opacity(0.1))
                    .frame(width: 60, height: 60)

                if let image = getIcon() {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                        .foregroundColor(Color(hexString: "#8347AD") ?? .purple)
                }
            }
            .padding(.bottom, 12)

            Text(title)
                .font(.custom("Public Sans", size: 20).weight(.semibold))
                .kerning(0.15)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(hexString: "#272930") ?? .black)
                .lineSpacing(12)
                .multilineTextAlignment(.center)

            Text(subtitle.uppercased())
                .font(.custom("Public Sans", size: 12).weight(.regular))
                .foregroundColor(Color(hexString: "#272930") ?? .black)
                .tracking(1.0)
                .lineSpacing(3)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 10)
    }

    private func getIcon() -> UIImage? {
        if let image = KhipuClientBundleHelper.image(named: iconName) {
            return image
        }
        return nil
    }
}

@available(iOS 15.0, *)
struct FormIconHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            FormIconHeader(
                iconName: "sign-in",
                title: "Banco Estado",
                subtitle: "Ingresa a tu banco"
            )
            .environmentObject(ThemeManager())

            FormIconHeader(
                iconName: "bank-icon",
                title: "Banco de Chile",
                subtitle: "Ingresa tus credenciales"
            )
            .environmentObject(ThemeManager())
        }
        .padding()
        .background(Color.white)
    }
}
