import SwiftUI
import KhenshinProtocol
import SwiftUI


@available(iOS 15.0.0, *)
struct WarningMessageComponent: View {
    let operationWarning: OperationWarning
    @ObservedObject public var viewModel: KhenshinViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: Dimens.verySmall) {
            Image(systemName: "clock.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: Dimens.larger, height: Dimens.larger)
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
            
            Spacer().frame(height: Dimens.moderatelyLarge)
            DetailSectionWarning(operationWarning: operationWarning,operationInfo: viewModel.uiState.operationInfo!,viewModel: viewModel)
            Spacer().frame(height: Dimens.moderatelyLarge)
            
            Spacer()
            MainButton(
                text: viewModel.uiState.translator.t("default.end.and.go.back"),
                enabled: true,
                onClick: {
                    viewModel.uiState.returnToApp = true
                }
            )
        }
        .padding(.all, Dimens.extraMedium)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

@available(iOS 15.0.0, *)
struct DetailSectionWarning: View {
    var operationWarning: OperationWarning
    var operationInfo: OperationInfo
    @ObservedObject public var viewModel: KhenshinViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: Dimens.verySmall) {
            Text(viewModel.uiState.translator.t("default.detail.label"))
                .foregroundColor(Color(.label))
                .font(.headline)
                .fontWeight(.bold)
            DetailItemWarning(label: viewModel.uiState.translator.t("default.amount.label"), value: operationInfo.amount ?? "")
            DetailItemWarning(label: viewModel.uiState.translator.t("default.merchant.label"), value:operationInfo.merchant?.name ?? "")
            DetailItemWarning(label: viewModel.uiState.translator.t("default.operation.code.short.label"), value: FieldUtils.formatOperationId(operationId: operationWarning.operationID)+" "+FieldUtils.getFailureReasonCode(reason: operationWarning.reason),shouldCopyValue: true)
        }
    }
}

@available(iOS 15.0.0, *)
struct DetailItemWarning: View {
    var label: String
    var value: String
    var shouldCopyValue: Bool = false
    
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
        .padding(.vertical, Dimens.verySmall)
    }
}

