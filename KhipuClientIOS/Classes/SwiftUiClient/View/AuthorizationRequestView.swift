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
            QrAuthorizationRequestView(authorizationRequest: authorizationRequest)
        default:
            EmptyView()
        }
    }
}


@available(iOS 15.0.0, *)
struct QrAuthorizationRequestView: View {
    var authorizationRequest: AuthorizationRequest
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing:Dimens.Spacing.extraSmall) {
            if let base64String = authorizationRequest.imageData?.split(separator: ",").last,
               let imageData = Data(base64Encoded: String(base64String)) {
                if let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.5)
                        .accessibility(identifier: "ImageChallengeImage")
                } else {
                    Text("Unable to load image")
                }
            } else {
                Text("Invalid image data")
            }
            
            Text(authorizationRequest.message)
        }
        .padding(.horizontal,Dimens.Padding.extraMedium)
        .frame(maxWidth: .infinity, alignment: .center)
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
        return QrAuthorizationRequestView(authorizationRequest: MockDataGenerator.createAuthorizationRequest(authorizationType: .qr)).environmentObject(ThemeManager())
    }
}

@available(iOS 15.0, *)
struct MobileAuthorizationRequestView_Previews: PreviewProvider {
    static var previews: some View {
        return MobileAuthorizationRequestView(authorizationRequest: MockDataGenerator.createAuthorizationRequest(authorizationType: .mobile), translator: MockDataGenerator.createTranslator(), bank: "Banco").environmentObject(ThemeManager())
    }
}
