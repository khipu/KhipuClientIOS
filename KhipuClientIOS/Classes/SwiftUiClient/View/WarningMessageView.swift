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
                
                Image(systemName: "clock.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Dimens.Image.slightlyLarger, height: Dimens.Image.slightlyLarger)
                    .foregroundColor(themeManager.selectedTheme.colors.tertiary)
                
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .top)
            .cornerRadius(8)
            
            VStack(alignment: .center, spacing:Dimens.Spacing.medium) {
                Text(translator.t("page.operationWarning.failure.after.notify.pre.header"))
                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 24))
                    .multilineTextAlignment(.center)
                    .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .top)
            .cornerRadius(8)
            
            HStack(alignment: .center, spacing:Dimens.Spacing.medium) {
                Text((operationWarning.title)!)
                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 16))
                    .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal,Dimens.Padding.moderatelyLarge)
            .padding(.vertical, 0)
            .frame(maxWidth: .infinity, alignment: .center)
            
            FormWarning(text: operationWarning.body ?? "")
            Spacer().frame(height:Dimens.Spacing.large)
            

            DetailSectionComponent(
                operationId: operationWarning.operationID!,
                                reason: operationWarning.reason,
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

/*
 @available(iOS 15.0, *)
 struct WarningMessageComponent_Previews:PreviewProvider{
 static var previews: some View{
 return WarningMessageComponent(operationWarning:
 OperationWarning(
 type: MessageType.operationWarning,
 body: "body",
 events: nil,
 exitURL: "exitUrl",
 operationID: "operationID",
 resultMessage: "resultMessage",
 title: "Title",
 reason: FailureReasonType.taskDumped
 ), viewModel: KhipuViewModel()
 )
 .environmentObject(ThemeManager())
 .padding()
 }
 }
 */
