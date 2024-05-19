import SwiftUI
import KhenshinProtocol
import SwiftUI


@available(iOS 15.0.0, *)
struct FailureMessageComponent: View {
    let operationFailure: OperationFailure
    @ObservedObject public var viewModel: KhipuViewModel
    @ObservedObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .center, spacing: Dimens.verySmall) {
            Image(systemName: "info.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: Dimens.larger, height: Dimens.larger)
                .foregroundColor(themeManager.selectedTheme.tertiary)
            Text(viewModel.uiState.translator.t("page.operationFailure.header.text.operation.task.finished"))
                .foregroundColor(themeManager.selectedTheme.onSurface)
                .font(.title2)
                .multilineTextAlignment(.center)
            
            Text((operationFailure.title)!)
                .foregroundColor(themeManager.selectedTheme.onSurface)
                .font(.title3)
                .multilineTextAlignment(.center)
            
            FormWarning(text: operationFailure.body ?? "", themeManager: themeManager)
            
            Spacer().frame(height: Dimens.moderatelyLarge)
            DetailSectionFailure(operationFailure: operationFailure, operationInfo: viewModel.uiState.operationInfo, viewModel: viewModel, themeManager: themeManager)
            Spacer().frame(height: Dimens.moderatelyLarge)
            MainButton(
                text: viewModel.uiState.translator.t("default.end.and.go.back"),
                enabled: true,
                onClick: {
                    viewModel.uiState.returnToApp = true
                },
                foregroundColor: themeManager.selectedTheme.onTertiary,
                backgroundColor: themeManager.selectedTheme.tertiary
            )
        }
        .padding(.all, Dimens.extraMedium)
    }
}

@available(iOS 15.0.0, *)
struct DetailSectionFailure: View {
    var operationFailure: OperationFailure
    var operationInfo: OperationInfo?
    @ObservedObject public var viewModel: KhipuViewModel
    @ObservedObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .center, spacing: Dimens.verySmall) {
            Text(viewModel.uiState.translator.t("default.detail.label"))
                .foregroundColor(themeManager.selectedTheme.onSurface)
                .font(.headline)
                .fontWeight(.bold)
            DetailItemFailure(label: viewModel.uiState.translator.t("default.amount.label"), value: operationInfo?.amount ?? "", themeManager: themeManager)
            DetailItemFailure(label: viewModel.uiState.translator.t("default.merchant.label"), value:operationInfo?.merchant?.name ?? "", themeManager: themeManager)
            DetailItemFailure(label: viewModel.uiState.translator.t("default.operation.code.short.label"), value: FieldUtils.formatOperationId(operationId: operationFailure.operationID)+" "+FieldUtils.getFailureReasonCode(reason: operationFailure.reason),shouldCopyValue: true, themeManager: themeManager)
        }
    }
}

@available(iOS 15.0.0, *)
struct DetailItemFailure: View {
    var label: String
    var value: String
    var shouldCopyValue: Bool = false
    @ObservedObject var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(themeManager.selectedTheme.onSurfaceVariant)
                .font(.body)
            Spacer()
            if !shouldCopyValue {
                Text(value)
                    .foregroundColor(themeManager.selectedTheme.onSurface)
                    .font(.body)
            } else {
                CopyToClipboardOperationId(text: value, textToCopy: FieldUtils.formatOperationId(operationId:value), background: themeManager.selectedTheme.secondaryContainer)
            }
        }
        .padding(.vertical, Dimens.verySmall)
    }
}

