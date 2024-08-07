import KhenshinProtocol
import SwiftUI
import Combine

@available(iOS 15.0.0, *)
struct RedirectToManualView: View {
    let operationFailure: OperationFailure
    var translator: KhipuTranslator
    var operationInfo: OperationInfo
    var restartPayment: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    @State private var remainingSeconds = 25
    private var timer: Publishers.Autoconnect<Timer.TimerPublisher> {
        Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    private var redirectText: String {
        translator.t("default.redirect.n.seconds").replacingOccurrences(of: "{{time}}", with: "\(remainingSeconds)")
    }
    
    private func openManualUrl() {
        if let url = URL(string: "\(operationInfo.urls?.manualTransfer ?? "")?fallback=true") {
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
                
                FailureMessageHeaderComponent(title:translator.t("page.redirectManual.redirecting") ,subtitle: translator.t("page.redirectManual.only.regular"),bodyText: translator.t("default.user.regular.transfer") + " " + translator.t("page.redirectManual.other.bank"))
                
                VStack(alignment: .center, spacing:Dimens.Spacing.large) {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .frame(width: Dimens.Image.huge, height: Dimens.Image.huge)
                        .foregroundStyle(themeManager.selectedTheme.colors.onSurfaceVariant)
                    
                    HStack(alignment: .center, spacing: Dimens.Spacing.medium) {
                        Text(redirectText)
                            .foregroundColor(themeManager.selectedTheme.colors.onSurface)
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
                    text: translator.t("default.user.regular.transfer"),
                    enabled: true,
                    onClick: {
                        openManualUrl()
                    },
                    foregroundColor: themeManager.selectedTheme.colors.onTertiary,
                    backgroundColor: themeManager.selectedTheme.colors.tertiary
                )
                
                
                MainButton(
                    text: translator.t("default.user.other.bank"),
                    enabled: true,
                    onClick: restartPayment
                    ,
                    foregroundColor: themeManager.selectedTheme.colors.onSurface,
                    backgroundColor: themeManager.selectedTheme.colors.surface
                ).cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius:Dimens.CornerRadius.extraSmall)
                            .inset(by: 0.5)
                            .stroke(themeManager.selectedTheme.colors.onSurface, lineWidth: 1))
            }
            .padding(.horizontal,Dimens.Padding.large)
            .padding(.vertical,Dimens.Padding.quiteLarge)
            .frame(maxWidth: .infinity, alignment: .top)
        }
    }
}



    
     @available(iOS 15.0, *)
     struct RedirectToManualView_Previews: PreviewProvider{
     static var previews: some View{
         
         return RedirectToManualView(operationFailure: MockDataGenerator.createOperationFailure(reason: .bankWithoutAutomaton), translator: MockDataGenerator.createTranslator(), operationInfo: MockDataGenerator.createOperationInfo(), restartPayment: {})
     .environmentObject(ThemeManager())
     .padding()
     }
    }
     
