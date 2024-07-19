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
        .padding(.horizontal,Dimens.Padding.large)
        .padding(.vertical,Dimens.Padding.quiteLarge)
        .frame(maxWidth: .infinity, alignment: .top)
    }
    
}

/*

@available(iOS 15.0, *)
struct FailureMessageComponent_Previews: PreviewProvider {
    static var previews: some View {
        FailureMessageComponent(
            operationFailure:
                OperationFailure(
                    type: MessageType.operationFailure,
                    body: "body",
                    events: nil,
                    exitURL: "exitUrl",
                    operationID: "operationID",
                    resultMessage: "resultMessage",
                    title: "Title",
                    reason: FailureReasonType.taskExecutionError
                ), viewModel: KhipuViewModel())
        .environmentObject(ThemeManager())
        .padding()
    }
}
*/
