import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct SuccessMessageComponent: View {
    let operationSuccess: OperationSuccess
    @ObservedObject public var viewModel: KhipuViewModel
    @ObservedObject var themeManager: ThemeManager
    
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: Dimens.extraLarge))
                .foregroundColor(themeManager.selectedTheme.success)
            Spacer().frame(height: Dimens.moderatelyLarge)
            Text(operationSuccess.title ?? "")
                .font(.title2)
                .foregroundColor(themeManager.selectedTheme.onBackground)
            Spacer().frame(height: Dimens.extraSmall)
            Text(operationSuccess.body ?? "")
                .font(.body)
                .foregroundColor(themeManager.selectedTheme.onBackground)
                .multilineTextAlignment(.center)
            Spacer().frame(height: Dimens.moderatelyLarge)
            Text(viewModel.uiState.translator.t("default.operation.code.label"))
                .font(.footnote)
                .foregroundColor(themeManager.selectedTheme.onBackground)
            Spacer().frame(height: Dimens.extraSmall)
            Text(formatOperationId(operationSuccess.operationID ?? ""))
                .font(.body)
                .foregroundColor(themeManager.selectedTheme.primary)
                .padding(.horizontal, Dimens.extraMedium)
                .padding(.vertical, Dimens.extraSmall)
                .background(
                    Color(uiColor: .lightGray)
                        .opacity(0.3)
                        .cornerRadius(Dimens.extraSmall)
                )
            Spacer().frame(height: Dimens.veryLarge)
            MainButton(
                text: viewModel.uiState.translator.t("default.end.and.go.back"),
                enabled: true,
                onClick: {
                    viewModel.uiState.returnToApp = true
                },
                foregroundColor: themeManager.selectedTheme.onSuccess,
                backgroundColor: themeManager.selectedTheme.success
            )
        }.padding(.all, Dimens.extraMedium)
    }
}

