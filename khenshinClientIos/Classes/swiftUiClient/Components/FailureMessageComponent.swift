import SwiftUI
import KhenshinProtocol
import SwiftUI


@available(iOS 15.0.0, *)
struct FailureMessageComponent: View {
    let operationFailure: OperationFailure
    @StateObject private var khenshinViewModel = KhenshinViewModel()

    var body: some View {
        VStack(alignment: .center, spacing: Dimens.verySmall) {
            Image(systemName: "info.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: Dimens.larger, height: Dimens.larger)
                .foregroundColor(Color(red: 234/255, green: 197/255, blue: 79/255))
            Text(khenshinViewModel.uiState.translator.t("page.operationFailure.header.text.operation.task.finished"))
                .foregroundColor(Color(.label))
                .font(.title2)
                .multilineTextAlignment(.center)

            Text((operationFailure.title)!)
                .foregroundColor(Color(.label))
                .font(.title3)
                .multilineTextAlignment(.center)

            FormWarning(text: operationFailure.body ?? "")

            Spacer().frame(height: Dimens.moderatelyLarge)
            DetailSection(operationFailure: operationFailure,operationInfo: khenshinViewModel.uiState.operationInfo!,khenshinViewModel: khenshinViewModel)
            Spacer().frame(height: Dimens.moderatelyLarge)

            Spacer()
            MainButton(
                text: khenshinViewModel.uiState.translator.t("default.end.and.go.back"),
                enabled: true,
                onClick: {
                    khenshinViewModel.uiState.returnToApp = true
                }
            )
        }
        .padding(.all, Dimens.extraMedium)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

@available(iOS 15.0.0, *)
struct DetailSection: View {
    var operationFailure: OperationFailure
    var operationInfo: OperationInfo
    @ObservedObject public var khenshinViewModel: KhenshinViewModel

    var body: some View {
        VStack(alignment: .center, spacing: Dimens.verySmall) {
            Text(khenshinViewModel.uiState.translator.t("default.detail.label"))
                .foregroundColor(Color(.label))
                .font(.headline)
                .fontWeight(.bold)
            DetailItemFailure(label: khenshinViewModel.uiState.translator.t("default.amount.label"), value: operationInfo.amount ?? "")
            DetailItemFailure(label: khenshinViewModel.uiState.translator.t("default.merchant.label"), value:operationInfo.merchant?.name ?? "")
            DetailItemFailure(label: khenshinViewModel.uiState.translator.t("default.operation.code.short.label"), value: FieldUtils.formatOperationId(operationId: operationFailure.operationID)+" "+FieldUtils.getFailureReasonCode(reason: operationFailure.reason),shouldCopyValue: true)
        }
    }
}

@available(iOS 15.0.0, *)
struct DetailItemFailure: View {
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

