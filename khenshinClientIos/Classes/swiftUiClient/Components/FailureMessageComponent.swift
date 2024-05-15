import SwiftUI
import KhenshinProtocol
import SwiftUI

// Define the dimension values based on the provided Kotlin dimensions.
struct Dimensions {
    static let dpExtraSmall: CGFloat = 8
    static let dpExtraMedium: CGFloat = 16
    static let dpModeratelyLarge: CGFloat = 24
    static let dpExtraLarge: CGFloat = 54
    static let dpVerySmall: CGFloat = 4
    static let dpNone: CGFloat = 0
}
@available(iOS 15.0.0, *)
struct FailureMessageComponent: View {
    @ObservedObject public var viewModel: KhenshinViewModel

    var body: some View {
        VStack(alignment: .center, spacing: Dimensions.dpVerySmall) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: Dimensions.dpExtraLarge, height: Dimensions.dpExtraLarge)
                .foregroundColor(Color(.systemTeal))
            Text(viewModel.uiState.translator.t("page.operationFailure.header.text.operation.task.finished"))
                .foregroundColor(Color(.label))
                .font(.headline)
                .multilineTextAlignment(.center)

            Text((viewModel.uiState.operationFailure?.title)!)
                .foregroundColor(Color(.label))
                .font(.title3)
                .multilineTextAlignment(.center)


            Spacer().frame(height: Dimensions.dpModeratelyLarge)
            DetailSection(operationFailure: viewModel.uiState.operationFailure!, viewModel: viewModel)
            Spacer().frame(height: Dimensions.dpModeratelyLarge)

            /*
            Button(action: viewModel.uiState.returnToApp) {
                Text(viewModel.uiState.translator.t("default.end.and.go.back"))
            }
            .buttonStyle(.filled)
            .tint(Color(.systemTertiary))
            .enabled(true)*/
        }
        .padding(.all, Dimensions.dpExtraMedium)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

@available(iOS 15.0.0, *)
struct DetailSection: View {
    var operationFailure: OperationFailure
    @ObservedObject public var viewModel: KhenshinViewModel

    var body: some View {
        VStack(alignment: .center, spacing: Dimensions.dpVerySmall) {
            Text(viewModel.uiState.translator.t("default.detail.label"))
                .foregroundColor(Color(.label))
                .font(.headline)
                .fontWeight(.bold)

            DetailItemFailure(label: viewModel.uiState.translator.t("default.amount.label"), value: viewModel.uiState.operationInfo?.amount ?? "")
            DetailItemFailure(label: viewModel.uiState.translator.t("default.merchant.label"), value: viewModel.uiState.operationInfo?.merchant?.name ?? "")
            DetailItemFailure(label: viewModel.uiState.translator.t("default.operation.code.short.label"), value: FieldUtils.formatOperationId(operationId: viewModel.uiState.operationFailure?.operationID))
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
            } /*else {
                CopyToClipboardOperationId(text: value, textToCopy: formatOperationId(value))
                    .background(Color(.systemGray5))
            }*/
        }
        .padding(.vertical, Dimensions.dpVerySmall)
    }
}

