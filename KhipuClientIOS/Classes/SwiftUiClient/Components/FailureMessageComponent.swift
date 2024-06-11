import SwiftUI
import KhenshinProtocol


@available(iOS 15.0.0, *)
struct FailureMessageComponent: View {
    let operationFailure: OperationFailure
    @ObservedObject public var viewModel: KhipuViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .center, spacing: themeManager.selectedTheme.dimens.verySmall) {
            Image(systemName: "info.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: themeManager.selectedTheme.dimens.larger, height: themeManager.selectedTheme.dimens.larger)
                .foregroundColor(themeManager.selectedTheme.colors.tertiary)
            Text(viewModel.uiState.translator.t("page.operationFailure.header.text.operation.task.finished"))
                .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                .font(.title2)
                .multilineTextAlignment(.center)
            
            Text((operationFailure.title)!)
                .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                .font(.title3)
                .multilineTextAlignment(.center)
            
            FormWarning(text: operationFailure.body ?? "")
            
            Spacer().frame(height: themeManager.selectedTheme.dimens.moderatelyLarge)
            DetailSectionFailure(operationFailure: operationFailure, operationInfo: viewModel.uiState.operationInfo, viewModel: viewModel)
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
struct DetailSectionFailure: View {
    var operationFailure: OperationFailure
    var operationInfo: OperationInfo?
    @ObservedObject public var viewModel: KhipuViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .center, spacing: themeManager.selectedTheme.dimens.verySmall) {
            Text(viewModel.uiState.translator.t("default.detail.label"))
                .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                .font(.headline)
                .fontWeight(.bold)
            DetailItemFailure(label: viewModel.uiState.translator.t("default.amount.label"), value: operationInfo?.amount ?? "")
            DetailItemFailure(label: viewModel.uiState.translator.t("default.merchant.label"), value:operationInfo?.merchant?.name ?? "")
            DetailItemFailure(label: viewModel.uiState.translator.t("default.operation.code.short.label"), value: FieldUtils.formatOperationId(operationId: operationFailure.operationID)+" "+FieldUtils.getFailureReasonCode(reason: operationFailure.reason),shouldCopyValue: true)
        }
    }
}

@available(iOS 15.0.0, *)
struct DetailItemFailure: View {
    var label: String
    var value: String
    var shouldCopyValue: Bool = false
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(themeManager.selectedTheme.colors.onSurfaceVariant)
                .font(.body)
            Spacer()
            if !shouldCopyValue {
                Text(value)
                    .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                    .font(.body)
            } else {
                CopyToClipboardOperationId(text: value, textToCopy: FieldUtils.formatOperationId(operationId:value), background: themeManager.selectedTheme.colors.secondaryContainer)
            }
        }
        .padding(.vertical, themeManager.selectedTheme.dimens.verySmall)
    }
}


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

@available(iOS 15.0, *)
struct DetailSectionFailure_Previews: PreviewProvider {
    static var previews: some View {
        DetailSectionFailure(
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


@available(iOS 15.0, *)
struct DetailItemFailure_Previews: PreviewProvider {
    static var previews: some View {
        DetailItemFailure(
            label: "Label",
            value: "Value"
        )
        .environmentObject(ThemeManager())
        .padding()
    }
}
