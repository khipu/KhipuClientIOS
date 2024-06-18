import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct SuccessMessageComponent: View {
    let operationSuccess: OperationSuccess
    @ObservedObject public var viewModel: KhipuViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack {
            Group {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: themeManager.selectedTheme.dimens.extraLarge))
                    .foregroundColor(themeManager.selectedTheme.colors.success)
                Spacer().frame(height: themeManager.selectedTheme.dimens.moderatelyLarge)
                Text(operationSuccess.title ?? "")
                    .font(.title2)
                    .foregroundColor(themeManager.selectedTheme.colors.onBackground)
                Spacer().frame(height: themeManager.selectedTheme.dimens.extraSmall)
            }
            Group {
                Text(operationSuccess.body ?? "")
                    .font(.body)
                    .foregroundColor(themeManager.selectedTheme.colors.onBackground)
                    .multilineTextAlignment(.center)
                Spacer().frame(height: themeManager.selectedTheme.dimens.moderatelyLarge)
                Text(viewModel.uiState.translator.t("default.operation.code.label"))
                    .font(.footnote)
                    .foregroundColor(themeManager.selectedTheme.colors.onBackground)
                Spacer().frame(height: themeManager.selectedTheme.dimens.extraSmall)
            }
            Group {
                Text(FieldUtils.formatOperationId(operationId: operationSuccess.operationID ?? ""))
                    .font(.body)
                    .foregroundColor(themeManager.selectedTheme.colors.primary)
                    .padding(.horizontal, themeManager.selectedTheme.dimens.extraMedium)
                    .padding(.vertical, themeManager.selectedTheme.dimens.extraSmall)
                    .background(
                        Color(uiColor: .lightGray)
                            .opacity(0.3)
                            .cornerRadius(themeManager.selectedTheme.dimens.extraSmall)
                    )
                Spacer().frame(height: themeManager.selectedTheme.dimens.veryLarge)
            }
            MainButton(
                text: viewModel.uiState.translator.t("default.end.and.go.back"),
                enabled: true,
                onClick: {
                    viewModel.uiState.returnToApp = true
                },
                foregroundColor: themeManager.selectedTheme.colors.onSuccess,
                backgroundColor: themeManager.selectedTheme.colors.success
            )
        }.padding(.all, themeManager.selectedTheme.dimens.extraMedium)
    }
}

@available(iOS 15.0, *)
struct SuccessMessageComponent_Previews: PreviewProvider{
    static var previews: some View{
        
        return SuccessMessageComponent(operationSuccess: OperationSuccess(
                canUpdateEmail: false,
                type: MessageType.operationSuccess,
                body: "body",
                events: nil,
                exitURL: "exitUrl",
                operationID: "operationID",
                resultMessage: "resultMessage",
                title: "Title"
            ), viewModel: KhipuViewModel()
        )
        .environmentObject(ThemeManager())
        .padding()
    }
}
