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
        VStack(alignment: .center, spacing:Dimens.Spacing.large) {
            FailureMessageHeaderComponent(icon: "info.circle.fill",title:translator.t("page.operationFailure.header.text.operation.task.finished") ,subtitle: (operationMustContinue.title)!,bodyText: operationMustContinue.body)
            InformationSection(translator: translator, operationInfo: operationInfo)
            DetailSectionComponent(
                operationId: operationMustContinue.operationID!,
                reason: operationMustContinue.reason,
                                params: DetailSectionParams(
                                    amountLabel: translator.t("default.amount.label"),
                                    amountValue: operationInfo.amount!,
                                    codOperacionLabel: translator.t("default.operation.code.short.label"),
                                    merchantNameLabel: translator.t("default.merchant.label"),
                                    merchantNameValue: operationInfo.merchant?.name ?? nil
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
        .padding(.horizontal,Dimens.Padding.large)
        .padding(.vertical,Dimens.Padding.quiteLarge)
        .frame(maxWidth: .infinity, alignment: .top)
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


@available(iOS 15.0, *)
struct MustContinueViewCMR_Previews:PreviewProvider{
    static var previews: some View{
        return MustContinueView(operationMustContinue: MockDataGenerator.createOperationMustContinue(),
                                translator: MockDataGenerator.createTranslator(),
                                operationInfo: MockDataGenerator.createOperationInfo(),
                                returnToApp: {  }).environmentObject(ThemeManager())
            .previewLayout(.sizeThatFits)
        
    }
}

@available(iOS 15.0, *)
struct MustContinueView_Previews:PreviewProvider{
    static var previews: some View{
        return MustContinueView(operationMustContinue: MockDataGenerator.createOperationMustContinue(),
                                translator: MockDataGenerator.createTranslator(),
                                operationInfo: MockDataGenerator.createOperationInfo(merchantLogo: "logo",merchantName: "Demo Merchant"),
                                returnToApp: {  }).environmentObject(ThemeManager())
            .previewLayout(.sizeThatFits)
        
    }
}


