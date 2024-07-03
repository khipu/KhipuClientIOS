import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct SuccessMessageComponent: View {
    let operationSuccess: OperationSuccess
    @ObservedObject public var viewModel: KhipuViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .center, spacing: themeManager.selectedTheme.dimens.large) {
            VStack(alignment: .center, spacing: themeManager.selectedTheme.dimens.medium) {
                let image = UIImage.fontAwesomeIcon(name: .checkCircle, style: .solid, textColor: UIColor(themeManager.selectedTheme.colors.success), size: CGSize(width: themeManager.selectedTheme.dimens.slightlyLarger, height: themeManager.selectedTheme.dimens.slightlyLarger))
                Image(uiImage: image)
                
                HStack(alignment: .top, spacing: themeManager.selectedTheme.dimens.medium) {   Text(operationSuccess.title ?? "")
                        .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 20))
                    .foregroundColor(themeManager.selectedTheme.colors.onBackground)}
                .padding(.horizontal, 10)
                .padding(.vertical, 0)
                .frame(maxWidth: .infinity, alignment: .top)
                
                VStack(alignment: .center, spacing: themeManager.selectedTheme.dimens.medium) {
                    Text(operationSuccess.body ?? "")
                        .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 16))
                        .foregroundColor(themeManager.selectedTheme.colors.onBackground)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 0)
                .padding(.vertical, themeManager.selectedTheme.dimens.medium)
                .frame(maxWidth: .infinity, alignment: .center)
                .cornerRadius(8)
                
                Text(viewModel.uiState.translator.t("default.operation.code.label"))
                    .foregroundColor(themeManager.selectedTheme.colors.labelForeground)
                    .font(themeManager.selectedTheme.fonts.font(style: .regular, size: 14))
                    .multilineTextAlignment(.center)
                CopyToClipboardOperationId(
                    text: operationSuccess.operationID ?? "",
                    textToCopy: FieldUtils.formatOperationId(operationId: operationSuccess.operationID ?? ""),
                    background:themeManager.selectedTheme.colors.onSecondaryContainer)
                
                
            }
            .padding(.horizontal, 0)
            .padding(.vertical, themeManager.selectedTheme.dimens.medium)
            .frame(maxWidth: .infinity, alignment: .center)
            .cornerRadius(themeManager.selectedTheme.dimens.extraSmall)
            
            MainButton(
                text: viewModel.uiState.translator.t("default.end.and.go.back"),
                enabled: true,
                onClick: {
                    viewModel.uiState.returnToApp = true
                },
                foregroundColor: themeManager.selectedTheme.colors.onSuccess,
                backgroundColor: themeManager.selectedTheme.colors.success
            )
            
        }
        .padding(.horizontal, themeManager.selectedTheme.dimens.large)
        .padding(.vertical, themeManager.selectedTheme.dimens.quiteLarge)
        .frame(maxWidth: .infinity, alignment: .center)
        
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
