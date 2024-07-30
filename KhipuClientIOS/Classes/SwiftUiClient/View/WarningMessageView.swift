import SwiftUI
import KhenshinProtocol
import SwiftUI

@available(iOS 15.0.0, *)
struct WarningMessageView: View {
    var operationWarning: OperationWarning
    var operationInfo: OperationInfo
    var translator: KhipuTranslator
    var returnToApp: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        
        VStack(alignment: .center, spacing:Dimens.Spacing.large) {
            VStack(alignment: .center, spacing:Dimens.Spacing.medium) {
                
                FailureMessageHeaderComponent(icon: "clock.fill",title:translator.t("page.operationWarning.failure.after.notify.pre.header") ,subtitle: (operationWarning.title)!,bodyText: operationWarning.body)
                DetailSectionComponent(
                    operationId: operationWarning.operationID!,
                    reason: operationWarning.reason,
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
                    onClick:returnToApp,
                    foregroundColor: themeManager.selectedTheme.colors.onTertiary,
                    backgroundColor: themeManager.selectedTheme.colors.tertiary
                )
            }
            .padding(.horizontal,Dimens.Padding.large)
            .padding(.vertical,Dimens.Padding.quiteLarge)
            .frame(maxWidth: .infinity, alignment: .top)
        }
    }
}

@available(iOS 15.0, *)
struct WarningMessageView_Previews: PreviewProvider{
    static var previews: some View{
                
        return WarningMessageView(operationWarning: MockDataGenerator.createOperationWarning(), operationInfo: MockDataGenerator.createOperationInfo(merchantLogo: "logo",merchantName: "Demo Merchant"), translator: MockDataGenerator.createTranslator(), returnToApp: {})
            .environmentObject(ThemeManager())
            .padding()
    }
}

@available(iOS 15.0, *)
struct WarningMessageViewCMR_Previews: PreviewProvider{
    static var previews: some View{
                
        return WarningMessageView(operationWarning: MockDataGenerator.createOperationWarning(), operationInfo: MockDataGenerator.createOperationInfo(), translator: MockDataGenerator.createTranslator(), returnToApp: {})
            .environmentObject(ThemeManager())
            .padding()
    }
}
