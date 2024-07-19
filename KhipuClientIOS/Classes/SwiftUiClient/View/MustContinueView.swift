import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct MustContinueView: View {
    var operationMustContinue: OperationMustContinue
    var translator: KhipuTranslator
    var operationInfo: OperationInfo
    var returnToApp: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager

    
    var body: some View {
        VStack(alignment: .center, spacing: Dimens.Spacing.large) {
            VStack(alignment: .center, spacing: Dimens.Spacing.extraMedium) {
                Image(systemName: "info.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Dimens.Image.slightlyLarger, height: Dimens.Image.slightlyLarger)
                    .foregroundColor(themeManager.selectedTheme.colors.tertiary)
                Text(translator.t("page.operationFailure.header.text.operation.task.finished"))
                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 24))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(themeManager.selectedTheme.colors.onSurface)
                Text((operationMustContinue.title)!)
                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(themeManager.selectedTheme.colors.onSurface)
                
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .top)
            
            FormWarning(text: operationMustContinue.body ?? "")
            InformationSection(translator: translator, operationInfo: operationInfo)

            DetailSectionComponent(
                operationId: operationMustContinue.operationID!,
                reason: operationMustContinue.reason,
                                params: DetailSectionParams(
                                    amountLabel: translator.t("default.amount.label"),
                                    amountValue: operationInfo.amount!,
                                    merchantNameLabel: translator.t("default.merchant.label"),
                                    merchantNameValue: (operationInfo.merchant?.name!)!,
                                    codOperacionLabel: translator.t("default.operation.code.short.label")
                                )
                            )
            
            
            
            

            MainButton(
                text: translator.t("default.end.and.go.back"),
                enabled: true,
                onClick: returnToApp,
                foregroundColor: themeManager.selectedTheme.colors.onTertiary,
                backgroundColor: themeManager.selectedTheme.colors.tertiary
            )
        }
        .padding(.horizontal, Dimens.Padding.large)
        .padding(.vertical, Dimens.Padding.quiteLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(
          Rectangle()
            .inset(by: 0.5)
            .stroke(Color(red: 0.85, green: 0.85, blue: 0.85), lineWidth: 1)
        )
    }
}

@available(iOS 15.0, *)
struct InformationSection: View {
    var translator: KhipuTranslator
    var operationInfo: OperationInfo
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .center, spacing:Dimens.Spacing.verySmall) {
            Text(translator.t("page.operationMustContinue.share.description"))
                .foregroundStyle(themeManager.selectedTheme.colors.onSurface)
                .font(themeManager.selectedTheme.fonts.font(style: .medium, size: 14))
                .multilineTextAlignment(.center)
            
            Spacer().frame(height:Dimens.Spacing.extraMedium)
            
            CopyToClipboardLink(
                text: operationInfo.urls?.info ?? "",
                textToCopy: operationInfo.urls?.info ?? "",
                background:themeManager.selectedTheme.colors.onSecondaryContainer)
            
            Spacer().frame(height:Dimens.Spacing.extraMedium)

            
            if #available(iOS 16.0, *) {
                ShareLink(item: URL(string: operationInfo.urls?.info ?? "")!,
                          message: Text(translator.t("page.operationMustContinue.share.link.body"))){
                    Label("Compartir", systemImage: "square.and.arrow.up")
                }
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius:Dimens.CornerRadius.moderatelySmall)
                .stroke(themeManager.selectedTheme.colors.onSurface, lineWidth: 0.3)
        )
    }
}


/*/

@available(iOS 15.0, *)
struct MustContinueComponent_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = KhipuViewModel()
        let urls = Urls(
            attachment: ["https://www.khipu.com"],
            cancel: "https://www.khipu.com",
            changePaymentMethod: "https://www.khipu.com",
            fallback: "https://www.khipu.com",
            image: "https://www.khipu.com",
            info: "https://www.khipu.com",
            manualTransfer: "https://www.khipu.com",
            urlsReturn: "https://www.khipu.com"
        )
        let uiState = KhipuUiState(operationInfo: OperationInfo(
                acceptManualTransfer: true,
                amount: "$ 1.000",
                body: "body",
                email: "khipu@khipu.com",
                merchant: nil,
                operationID: "operationID",
                subject: "Subject",
                type: MessageType.operationInfo,
                urls: urls,
                welcomeScreen: nil
            )
        )
        viewModel.uiState = uiState
        return MustContinueComponent(
            viewModel: viewModel,
            operationMustContinue: OperationMustContinue(
                type: MessageType.operationMustContinue,
                body: "body",
                events: nil,
                exitURL: "exitUrl",
                operationID: "operationID",
                resultMessage: "resultMessage",
                title: "Title",
                reason: nil
            )
        )
        .environmentObject(ThemeManager())
        .previewLayout(.sizeThatFits)
    }
}
*/
