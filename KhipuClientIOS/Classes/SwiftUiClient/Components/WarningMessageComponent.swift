import SwiftUI
import KhenshinProtocol
import SwiftUI
import FontAwesome_swift

@available(iOS 15.0.0, *)
struct WarningMessageComponent: View {
    let operationWarning: OperationWarning
    @ObservedObject public var viewModel: KhipuViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 20) {
            VStack(alignment: .center, spacing: 10) {
                
                let image = UIImage.fontAwesomeIcon(name: .clock, style: .solid, textColor: UIColor(themeManager.selectedTheme.colors.tertiary), size: CGSize(width: 40, height: 40))
                Image(uiImage: image)
                
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .top)
            .cornerRadius(8)
            
            VStack(alignment: .center, spacing: 10) {
                Text(viewModel.uiState.translator.t("page.operationWarning.failure.after.notify.pre.header"))
                    .font(themeManager.selectedTheme.fonts.semiBold24)
                    .multilineTextAlignment(.center)
                
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .top)
            .cornerRadius(8)
            
            HStack(alignment: .center, spacing: 10) {
                Text((operationWarning.title)!)
                    .font(themeManager.selectedTheme.fonts.semiBold16)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 0)
            .frame(maxWidth: .infinity, alignment: .center)
            
            FormWarning(text: operationWarning.body ?? "")
            Spacer().frame(height: themeManager.selectedTheme.dimens.large)
            DetailSectionWarning(operationWarning: operationWarning,operationInfo: viewModel.uiState.operationInfo, viewModel: viewModel)
            
            MainButton(
                text: viewModel.uiState.translator.t("default.end.and.go.back"),
                enabled: true,
                onClick: {
                    viewModel.uiState.returnToApp = true
                },
                foregroundColor: themeManager.selectedTheme.colors.onTertiary,
                backgroundColor: themeManager.selectedTheme.colors.tertiary
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 32)
        .frame(maxWidth: .infinity, alignment: .top)
    }
}

@available(iOS 15.0.0, *)
struct DetailSectionWarning: View {
    var operationWarning: OperationWarning
    var operationInfo: OperationInfo?
    @ObservedObject public var viewModel: KhipuViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text(viewModel.uiState.translator.t("default.detail.label"))
                .font(themeManager.selectedTheme.fonts.semiBold16)
            
            DetailItemWarning(label: viewModel.uiState.translator.t("default.amount.label"), value: operationInfo?.amount ?? "")
            
            DetailItemWarning(label: viewModel.uiState.translator.t("default.merchant.label"), value:operationInfo?.merchant?.name ?? "")
            DashedLine()
            DetailItemWarning(label: viewModel.uiState.translator.t("default.operation.code.short.label"), value: FieldUtils.formatOperationId(operationId: operationWarning.operationID)+" "+FieldUtils.getFailureReasonCode(reason: operationWarning.reason),shouldCopyValue: true)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .top)
        .cornerRadius(6)
    }
}

@available(iOS 15.0.0, *)
struct DetailItemWarning: View {
    var label: String
    var value: String
    var shouldCopyValue: Bool = false
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            Text(label)
                .font(themeManager.selectedTheme.fonts.medium14)
                .foregroundColor(themeManager.selectedTheme.colors.labelForeground)
            Spacer()
            if !shouldCopyValue {
                Text(value)
                    .font(themeManager.selectedTheme.fonts.semiBold14)
                
            } else {
                CopyToClipboardOperationId(text: value, textToCopy: FieldUtils.formatOperationId(operationId:value), background:themeManager.selectedTheme.colors.onSecondaryContainer)
            }
        }
        .padding(.vertical, themeManager.selectedTheme.dimens.verySmall)
    }
}

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

@available(iOS 15.0, *)
struct DetailSectionWarning_Previews:PreviewProvider{
    static var previews: some View{
        return DetailSectionWarning(
            operationWarning: OperationWarning(
                type: MessageType.operationWarning,
                body: "body",
                events: nil,
                exitURL: "exitUrl",
                operationID: "operationID",
                resultMessage: "resultMessage",
                title: "Title",
                reason: FailureReasonType.taskDumped
            ), operationInfo: OperationInfo(
                acceptManualTransfer: true,
                amount: "$ 1.000",
                body: "body",
                email: "khipu@khipu.com",
                merchant: nil,
                operationID: "operationID",
                subject: "Subject",
                type: MessageType.operationInfo,
                urls: nil,
                welcomeScreen: nil
            ), viewModel: KhipuViewModel()
        )
        .environmentObject(ThemeManager())
        .padding()
    }
}

@available(iOS 15.0, *)
struct DetailItemWarning_Previews:PreviewProvider{
    static var previews: some View{
        return DetailItemWarning(
            label: "Label",
            value: "Value",
            shouldCopyValue: true
        )
        .environmentObject(ThemeManager())
        .padding()
    }
}
