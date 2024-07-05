import KhenshinProtocol
import SwiftUI
import Combine

@available(iOS 15.0.0, *)
struct RedirectToManualComponent: View {
    let operationFailure: OperationFailure
    @ObservedObject public var viewModel: KhipuViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    @State private var remainingSeconds = 25
    private var timer: Publishers.Autoconnect<Timer.TimerPublisher> {
        Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    private var redirectText: String {
        viewModel.uiState.translator.t("default.redirect.n.seconds").replacingOccurrences(of: "{{time}}", with: "\(remainingSeconds)")
    }
    
    private func openManualUrl() {
        if let url = URL(string: "\(viewModel.uiState.operationInfo?.urls?.manualTransfer ?? "")?fallback=true") {
            DispatchQueue.main.async {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            print("Invalid URL")
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing:Dimens.Spacing.large) {
            VStack(alignment: .center, spacing:Dimens.Spacing.medium) {
                
                let image = UIImage.fontAwesomeIcon(name: .infoCircle, style: .solid, textColor: UIColor(themeManager.selectedTheme.colors.tertiary), size: CGSize(width:Dimens.Image.slightlyLarger, height:Dimens.Image.slightlyLarger))
                Image(uiImage: image)
                
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .top)
            .cornerRadius(8)
            
            VStack(alignment: .center, spacing:Dimens.Spacing.medium) {
                Text(viewModel.uiState.translator.t("page.redirectManual.redirecting"))
                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 24))
                    .multilineTextAlignment(.center)
                
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .top)
            .cornerRadius(8)
            
            HStack(alignment: .center, spacing:Dimens.Spacing.medium) {
                Text(viewModel.uiState.translator.t("page.redirectManual.only.regular"))
                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 16))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal,Dimens.Padding.moderatelyLarge)
            .padding(.vertical, 0)
            .frame(maxWidth: .infinity, alignment: .center)
            
            FormWarning(text: viewModel.uiState.translator.t("default.user.regular.transfer") + " " + viewModel.uiState.translator.t("page.redirectManual.other.bank"))
            
            VStack(alignment: .center, spacing:Dimens.Spacing.large) {
                Image(systemName: "paperplane.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.secondary)
                
                HStack(alignment: .center, spacing: Dimens.Spacing.medium) {
                    Text(redirectText)
                        .foregroundColor(themeManager.selectedTheme.colors.labelForeground)
                        .font(themeManager.selectedTheme.fonts.font(style: .medium, size: 16))
                        .multilineTextAlignment(.center)
                }
                .padding(10)
                .frame(maxWidth: .infinity, minHeight: Dimens.Frame.larger, maxHeight:Dimens.Frame.larger, alignment: .center)
                
            }
            .padding(.horizontal, 0)
            .padding(.vertical,Dimens.Padding.larger)
            .frame(maxWidth: .infinity, alignment: .center)
            .cornerRadius(Dimens.CornerRadius.moderatelySmall)
            .onReceive(timer) { _ in
                if remainingSeconds > 0 {
                    remainingSeconds -= 1
                } else {
                    openManualUrl()
                }
            }
            
            MainButton(
                text: viewModel.uiState.translator.t("default.user.regular.transfer"),
                enabled: true,
                onClick: {
                    openManualUrl()
                },
                foregroundColor: themeManager.selectedTheme.colors.onTertiary,
                backgroundColor: themeManager.selectedTheme.colors.tertiary
            )
        }
        .padding(.horizontal,Dimens.Padding.large)
        .padding(.vertical,Dimens.Padding.quiteLarge)
        .frame(maxWidth: .infinity, alignment: .top)
    }
}


@available(iOS 15.0, *)
struct RedirectToManualComponent_Previews: PreviewProvider{
    static var previews: some View{
        return RedirectToManualComponent(operationFailure:
                                        OperationFailure(
                                            type: MessageType.operationWarning,
                                            body: "body",
                                            events: nil,
                                            exitURL: "exitUrl",
                                            operationID: "operationID",
                                            resultMessage: "resultMessage",
                                            title: "Failure",
                                            reason: FailureReasonType.bankWithoutAutomaton
                                        ), viewModel: KhipuViewModel()
        )
        .environmentObject(ThemeManager())
        .padding()
    }
}
