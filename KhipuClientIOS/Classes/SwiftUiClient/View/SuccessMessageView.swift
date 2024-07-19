import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct SuccessMessageView: View {
    let operationSuccess: OperationSuccess
    var translator: KhipuTranslator
    var operationInfo: OperationInfo?
    var returnToApp: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .center, spacing:Dimens.Spacing.large) {
            VStack(alignment: .center, spacing:Dimens.Spacing.medium) {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Dimens.Image.slightlyLarger, height: Dimens.Image.slightlyLarger)
                    .foregroundColor(themeManager.selectedTheme.colors.success)
                
                HStack(alignment: .top, spacing:Dimens.Spacing.medium) {   Text(operationSuccess.title ?? "")
                        .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 20))
                    .foregroundColor(themeManager.selectedTheme.colors.onBackground)}
                .padding(.horizontal, Dimens.Padding.medium)
                .padding(.vertical, 0)
                .frame(maxWidth: .infinity, alignment: .top)
                
                VStack(alignment: .center, spacing:Dimens.Spacing.medium) {
                    Text(operationSuccess.body ?? "")
                        .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 16))
                        .foregroundColor(themeManager.selectedTheme.colors.onBackground)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 0)
                .padding(.vertical,Dimens.Padding.medium)
                .frame(maxWidth: .infinity, alignment: .center)
                .cornerRadius(8)
                
                if let operationInfo = operationInfo {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(translator.t("default.amount.label"))
                            .font(themeManager.selectedTheme.fonts.font(style: .regular, size: 14))
                            .multilineTextAlignment(.center)
                            .foregroundColor(themeManager.selectedTheme.colors.onSurfaceVariant)
                            .frame(maxWidth: .infinity, alignment: .top)
                        
                        Text(operationInfo.amount ?? "")
                            .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 14))
                            .multilineTextAlignment(.center)
                            .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                            .frame(maxWidth: .infinity, alignment: .top)
                        
                        Text(translator.t("default.merchant.label"))
                            .font(themeManager.selectedTheme.fonts.font(style: .regular, size: 14))
                            .multilineTextAlignment(.center)
                            .foregroundColor(themeManager.selectedTheme.colors.onSurfaceVariant)
                            .frame(maxWidth: .infinity, alignment: .top)
                        
                        Text(operationInfo.merchant?.name ?? "")
                            .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 14))
                            .multilineTextAlignment(.center)
                            .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                            .frame(maxWidth: .infinity, alignment: .top)
                        
                    }
                    .padding(.horizontal, 0)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                }

            
                Text(translator.t("default.operation.code.label"))
                    .foregroundColor(themeManager.selectedTheme.colors.onSurfaceVariant)
                    .font(themeManager.selectedTheme.fonts.font(style: .regular, size: 14))
                    .multilineTextAlignment(.center)
                CopyToClipboardOperationId(
                    text: operationSuccess.operationID ?? "",
                    textToCopy: FieldUtils.formatOperationId(operationId: operationSuccess.operationID ?? ""),
                    background:themeManager.selectedTheme.colors.onSecondaryContainer)
                
                
            }
            .padding(.horizontal, 0)
            .padding(.vertical,Dimens.Padding.medium)
            .frame(maxWidth: .infinity, alignment: .center)
            .cornerRadius(Dimens.CornerRadius.extraSmall)
            
            MainButton(
                text: translator.t("default.end.and.go.back"),
                enabled: true,
                onClick:returnToApp,
                foregroundColor: themeManager.selectedTheme.colors.onSuccess,
                backgroundColor: themeManager.selectedTheme.colors.success
            )
            
        }
        .padding(.horizontal,Dimens.Padding.large)
        .padding(.vertical,Dimens.Padding.quiteLarge)
        .frame(maxWidth: .infinity, alignment: .center)
        
    }
    
}

/*
@available(iOS 15.0, *)
struct SuccessMessageComponent_Previews: PreviewProvider{
    static var previews: some View{
        
        let viewModel = KhipuViewModel()
        viewModel.uiState.translator = KhipuTranslator(translations: [
            "default.amount.label": "Monto",
            "default.operation.code.label": "Código operación",
            "default.merchant.label": "Destinatario",
        ])
        let operationInfo = OperationInfo(
            acceptManualTransfer: true,
            amount: "1000",
            body: "Transaction Body",
            email: "example@example.com",
            merchant: Merchant(logo: "merchant_logo", name: "Merchant Name"),
            operationID: "12345",
            subject: "Transaction Subject",
            type: .operationInfo,
            urls: Urls(
                attachment: ["https://example.com/attachment"],
                cancel: "https://example.com/cancel",
                changePaymentMethod: "https://example.com/changePaymentMethod",
                fallback: "https://example.com/fallback",
                image: "https://example.com/image",
                info: "https://example.com/info",
                manualTransfer: "https://example.com/manualTransfer",
                urlsReturn: "https://example.com/return"
            ),
            welcomeScreen: WelcomeScreen(enabled: true, ttl: 3600)
        )
        
        viewModel.uiState.operationInfo = operationInfo

        
        return SuccessMessageComponent(operationSuccess: OperationSuccess(
            canUpdateEmail: false,
            type: MessageType.operationSuccess,
            body: "body",
            events: nil,
            exitURL: "exitUrl",
            operationID: "operationID",
            resultMessage: "resultMessage",
            title: "Title"
        ), viewModel: viewModel
        )
        .environmentObject(ThemeManager())
        .padding()
    }
 
}*/
