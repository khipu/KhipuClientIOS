import SwiftUI
import KhenshinProtocol
import SwiftUI


@available(iOS 15.0.0, *)
struct WarningMessageComponent: View {
    let operationWarning: OperationWarning
    @ObservedObject public var viewModel: KhipuViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .center, spacing: themeManager.selectedTheme.dimens.verySmall) {
            Image(systemName: "clock.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: themeManager.selectedTheme.dimens.larger, height: themeManager.selectedTheme.dimens.larger)
                .foregroundColor(Color(red: 234/255, green: 197/255, blue: 79/255))
            Text(viewModel.uiState.translator.t("page.operationWarning.failure.after.notify.pre.header"))
                .foregroundColor(Color(.label))
                .font(.title2)
                .multilineTextAlignment(.center)
            
            Text((operationWarning.title)!)
                .foregroundColor(Color(.label))
                .font(.title3)
                .multilineTextAlignment(.center)
            
            FormWarning(text: operationWarning.body ?? "")
            Spacer().frame(height: themeManager.selectedTheme.dimens.moderatelyLarge)
            DetailSectionWarning(operationWarning: operationWarning,operationInfo: viewModel.uiState.operationInfo, viewModel: viewModel)
            Spacer().frame(height: themeManager.selectedTheme.dimens.moderatelyLarge)
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
        .padding(.all, themeManager.selectedTheme.dimens.extraMedium)
    }
}

@available(iOS 15.0.0, *)
struct DetailSectionWarning: View {
    var operationWarning: OperationWarning
    var operationInfo: OperationInfo?
    @ObservedObject public var viewModel: KhipuViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .center, spacing: themeManager.selectedTheme.dimens.verySmall) {
            Text(viewModel.uiState.translator.t("default.detail.label"))
                .foregroundColor(Color(.label))
                .font(.headline)
                .fontWeight(.bold)
            DetailItemWarning(label: viewModel.uiState.translator.t("default.amount.label"), value: operationInfo?.amount ?? "")
            DetailItemWarning(label: viewModel.uiState.translator.t("default.merchant.label"), value:operationInfo?.merchant?.name ?? "")
            DetailItemWarning(label: viewModel.uiState.translator.t("default.operation.code.short.label"), value: FieldUtils.formatOperationId(operationId: operationWarning.operationID)+" "+FieldUtils.getFailureReasonCode(reason: operationWarning.reason),shouldCopyValue: true)
        }
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
                .foregroundColor(Color(.label))
                .font(.body)
            Spacer()
            if !shouldCopyValue {
                Text(value)
                    .foregroundColor(Color(.label))
                    .font(.body)
            } else {
                CopyToClipboardOperationId(text: value, textToCopy: FieldUtils.formatOperationId(operationId:value), background:Color(red: 60/255, green: 180/255, blue: 229/255))
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
