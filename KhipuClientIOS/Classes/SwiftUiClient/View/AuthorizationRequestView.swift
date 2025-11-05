import SwiftUI
import KhenshinProtocol

@available(iOS 15.0.0, *)
struct AuthorizationRequestView: View {
    var authorizationRequest: AuthorizationRequest
    var translator: KhipuTranslator
    var bank: String
    
    var body: some View {
        switch authorizationRequest.authorizationType {
        case .mobile:
            MobileAuthorizationRequestView(authorizationRequest: authorizationRequest,translator:translator, bank: bank)
        case .qr:
            QrAuthorizationRequestView(authorizationRequest: authorizationRequest,translator:translator, bank: bank)
        default:
            EmptyView()
        }
    }
}


@available(iOS 15.0.0, *)
struct QrAuthorizationRequestView: View {
    var authorizationRequest: AuthorizationRequest
    var translator: KhipuTranslator
    var bank: String
    
    @Environment(\.openURL) private var openURL
    @EnvironmentObject private var themeManager: ThemeManager
    
    @State private var qrURL: URL?
    @State private var isLoading = false
    @State private var errorMsg: String?
    @State private var uiImage: UIImage?
    
    var body: some View {
        VStack(spacing: Dimens.Spacing.large) {
            let messageParts = authorizationRequest.message.split(separator: "|", maxSplits: 1)
            if messageParts.count == 2 {
                VStack(spacing: Dimens.Spacing.small) {
                    Text(messageParts[0].trimmingCharacters(in: .whitespaces))
                        .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 16))
                    Text(messageParts[1].trimmingCharacters(in: .whitespaces))
                        .font(themeManager.selectedTheme.fonts.font(style: .regular, size: 14))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            } else {
                Text(authorizationRequest.message)
                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 16))
            }
            
            if !bank.isEmpty {
                FormPill(text: bank)
            }

            if let base64String = authorizationRequest.imageData?.split(separator: ",").last,
               let imageData = Data(base64Encoded: String(base64String)) {
                if let img = UIImage(data: imageData) {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.5)
                        .accessibility(identifier: "ImageChallengeImage")
                        .onAppear { decodeAndRead(image: img) }
                }
            } else {
                if authorizationRequest.imageData != nil {
                    ProgressView().accessibilityIdentifier("QRImageLoading")
                } else {
                    Text("Invalid image data")
                }
            }
            
            if let url = qrURL {
                MainButton(
                    text: translator.t("modal.authorization.open.qr.link.button"),
                    enabled: !isLoading,
                    onClick: { openURL(url) },
                    foregroundColor: themeManager.selectedTheme.colors.onPrimary,
                    backgroundColor: themeManager.selectedTheme.colors.primary
                )
            } else if let e = errorMsg {
                Text(e).font(.footnote).foregroundStyle(.secondary)
            }
            
            
        }
        .padding(.horizontal, Dimens.Padding.extraMedium)
        .frame(maxWidth: .infinity, alignment: .center)
        
    }
    
    // MARK: - Helpers
    
    private func decodeAndRead(image: UIImage) {
        errorMsg = nil
        qrURL = nil
        isLoading = true

        DispatchQueue.global(qos: .userInitiated).async {
            var url = extractSafeURLFromQRSync(
                image: image,
                blockedSchemes: ["javascript","data","file","vbscript"],
                allowHTTP: false,
                allowLocalNetworkHosts: false
            )

            if url == nil {
                url = extractSafeURLFromQRSync(
                    image: image,
                    blockedSchemes: ["javascript","data","file","vbscript"],
                    allowHTTP: true,
                    allowLocalNetworkHosts: false
                )
            }

            DispatchQueue.main.async {
                self.qrURL = url
                self.isLoading = false
                if url == nil {
                    self.errorMsg = "El QR no contiene una URL segura/permitida."
                }
            }
        }
    }
}


@available(iOS 15.0.0, *)
struct MobileAuthorizationRequestView: View {
    var authorizationRequest: AuthorizationRequest
    var translator: KhipuTranslator
    var bank: String
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .center, spacing: Dimens.Spacing.large) {
            HStack(alignment: .top, spacing: Dimens.Spacing.medium) {
                FormTitle(text: translator.t("modal.authorization.use.app"))
                
            }
            .padding(.horizontal, Dimens.Padding.medium)
            .padding(.vertical, 0)
            .frame(maxWidth: .infinity, alignment: .top)
            
            VStack(alignment: .center, spacing: Dimens.Spacing.medium) {
                
                if !bank.isEmpty {
                    FormPill(text: bank)
                }
                
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 0)
            .frame(maxWidth: .infinity, alignment: .center)
            .cornerRadius(40)
            
            
            VStack(alignment: .center, spacing: Dimens.Spacing.large) {
                if let image = KhipuClientBundleHelper.image(named: "authorize") {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Dimens.Image.extraHuge, height: Dimens.Image.extraHuge)
                }
            }
            .padding(.horizontal, Dimens.Padding.large)
            .padding(.vertical, Dimens.Padding.quiteLarge)
            .frame(maxWidth: .infinity, alignment: .top)
            .cornerRadius(Dimens.CornerRadius.moderatelySmall)
            
            
            VStack(alignment: .center, spacing: Dimens.Spacing.large) {
                Text(authorizationRequest.message)
                    .multilineTextAlignment(.center)
                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 16))
                
            }
            .padding(.horizontal, Dimens.Padding.large)
            .padding(.vertical, Dimens.Padding.quiteLarge)
            .frame(maxWidth: .infinity, alignment: .top)
            .cornerRadius(Dimens.CornerRadius.moderatelySmall)
            
            
            MainButton(
                text: translator.t("modal.authorization.wait"),
                enabled: false,
                onClick: {},
                foregroundColor: themeManager.selectedTheme.colors.onPrimary,
                backgroundColor: themeManager.selectedTheme.colors.primary
            )
        }
        .padding(.horizontal, Dimens.Padding.large)
        .padding(.vertical, Dimens.Padding.quiteLarge)
        .frame(maxWidth: .infinity, alignment: .top)
        .cornerRadius(Dimens.CornerRadius.moderatelySmall)
        
    }
}

@available(iOS 15.0, *)
struct QrAuthorizationRequestView_Previews: PreviewProvider {
    static var previews: some View {
        return QrAuthorizationRequestView(authorizationRequest: MockDataGenerator.createAuthorizationRequest(authorizationType: .qr),
                                          translator: MockDataGenerator.createTranslator(),
                                          bank: "Banco prueba")
        .environmentObject(ThemeManager())
    }
}

@available(iOS 15.0, *)
struct MobileAuthorizationRequestView_Previews: PreviewProvider {
    static var previews: some View {
        return MobileAuthorizationRequestView(authorizationRequest: MockDataGenerator.createAuthorizationRequest(authorizationType: .mobile), translator: MockDataGenerator.createTranslator(), bank: "Banco").environmentObject(ThemeManager())
    }
}
