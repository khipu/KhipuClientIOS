import SwiftUI
import KhenshinProtocol

@available(iOS 15.0.0, *)
struct AuthorizationRequestView: View {
    @ObservedObject public var viewModel: KhipuViewModel
    var body: some View {
        switch viewModel.uiState.currentAuthorizationRequest?.authorizationType {
        case .mobile:
            MobileAuthorizationRequestView(authorizationRequest: viewModel.uiState.currentAuthorizationRequest!,viewModel: viewModel)
        case .qr:
            QrAuthorizationRequestView(authorizationRequest: viewModel.uiState.currentAuthorizationRequest!,viewModel: viewModel)
        default:
            EmptyView()
        }
    }
}


@available(iOS 15.0.0, *)
struct QrAuthorizationRequestView: View {
    var authorizationRequest: AuthorizationRequest
    @ObservedObject public var viewModel: KhipuViewModel
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        VStack(spacing: themeManager.selectedTheme.dimens.extraSmall) {
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
        .padding(.horizontal, themeManager.selectedTheme.dimens.extraMedium)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

@available(iOS 15.0.0, *)
struct MobileAuthorizationRequestView: View {
    var authorizationRequest: AuthorizationRequest
    @ObservedObject public var viewModel: KhipuViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        
        VStack(spacing: themeManager.selectedTheme.dimens.extraSmall) {
            FormTitle(text: viewModel.uiState.translator.t("modal.authorization.use.app"))
            
            if !viewModel.uiState.bank.isEmpty {
                Text(viewModel.uiState.bank)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            
            Spacer().frame(height: themeManager.selectedTheme.dimens.moderatelyLarge)
            
            Image("authorize")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Spacer().frame(height: themeManager.selectedTheme.dimens.moderatelyLarge)
            
            Text(authorizationRequest.message)
                .multilineTextAlignment(.center)
            
            Spacer().frame(height: themeManager.selectedTheme.dimens.extraMedium)
            
            Button(action: {}) {
                Text(viewModel.uiState.translator.t("modal.authorization.wait"))
            }
            .disabled(true)
        }
        .padding(.horizontal, themeManager.selectedTheme.dimens.moderatelyLarge)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}
