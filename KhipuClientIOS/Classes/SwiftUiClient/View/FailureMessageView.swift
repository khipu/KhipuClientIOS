import SwiftUI
import KhenshinProtocol

@available(iOS 15.0.0, *)
struct FailureMessageView: View {
    var operationFailure: OperationFailure
    var operationInfo: OperationInfo
    var translator: KhipuTranslator
    var returnToApp: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        
        VStack(alignment: .center, spacing:Dimens.Spacing.large) {
            FailureMessageHeaderComponent(icon: "info.circle.fill",title:translator.t("page.operationFailure.header.text.operation.task.finished") ,subtitle: (operationFailure.title)!,bodyText: operationFailure.body)
            DetailSectionComponent(
                operationId: operationFailure.operationID!,
                                reason: operationFailure.reason,
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
struct FailureMessageViewCMR_Previews: PreviewProvider {
    static var previews: some View {
        FailureMessageView(operationFailure: MockDataGenerator.createOperationFailure(title: "No se pudo completar la transferencia"), operationInfo: MockDataGenerator.createOperationInfo(), translator: MockDataGenerator.createTranslator(), returnToApp: {})
        .environmentObject(ThemeManager())
        .padding()
    }
}


@available(iOS 15.0, *)
struct FailureMessageView_Previews: PreviewProvider {
    static var previews: some View {
        FailureMessageView(operationFailure: MockDataGenerator.createOperationFailure(title: "No se pudo completar la transferencia"), operationInfo: MockDataGenerator.createOperationInfo(merchantLogo: "logo",merchantName: "Merchant"), translator: MockDataGenerator.createTranslator(), returnToApp: {})
        .environmentObject(ThemeManager())
        .padding()
    }
}
