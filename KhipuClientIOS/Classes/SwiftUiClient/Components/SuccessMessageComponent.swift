import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct SuccessMessageComponent: View {
    let operationSuccess: OperationSuccess
    @ObservedObject public var viewModel: KhipuViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .center, spacing:Dimens.Spacing.large) {
            VStack(alignment: .center, spacing:Dimens.Spacing.medium) {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Dimens.Image.slightlyLarger, height: Dimens.Image.slightlyLarger)
                    .foregroundColor(themeManager.selectedTheme.colors.sucess)
                
                HStack(alignment: .top, spacing:Dimens.Spacing.medium) {   Text(operationSuccess.title ?? "")
                        .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 20))
                    .foregroundColor(themeManager.selectedTheme.colors.onBackground)}
                .padding(.horizontal, Dimens.Padding.medium)
                .padding(.vertical, 0)
                .frame(maxWidth: .infinity, alignment: .top)
                
                VStack(alignment: .center, spacing:Dimens.Spacing.medium) {
                    Text(operationSuccess.body ?? "")
                        .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 16))
                        .foregroundColor(themeManager.selectedTheme.colors.onBackground)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 0)
                .padding(.vertical,Dimens.Padding.medium)
                .frame(maxWidth: .infinity, alignment: .center)
                .cornerRadius(8)
                
                Text(viewModel.uiState.translator.t("default.operation.code.label"))
                    .foregroundColor(themeManager.selectedTheme.colors.onSurfaceVariant)
                    .font(themeManager.selectedTheme.fonts.font(style: .regular, size: 14))
                    .multilineTextAlignment(.center)
                CopyToClipboardOperationId(
                    text: operationSuccess.operationID ?? "",
                    textToCopy: FieldUtils.formatOperationId(operationId: operationSuccess.operationID ?? ""),
                    background:themeManager.selectedTheme.colors.onSecondaryContainer)
                
                
            }
            .padding(.horizontal, 0)
            .padding(.vertical,Dimens.Padding.medium)
            .frame(maxWidth: .infinity, alignment: .center)
            .cornerRadius(Dimens.CornerRadius.extraSmall)
            
            MainButton(
                text: viewModel.uiState.translator.t("default.end.and.go.back"),
                enabled: true,
                onClick: {
                    viewModel.uiState.returnToApp = true
                },
                foregroundColor: themeManager.selectedTheme.colors.onSucess,
                backgroundColor: themeManager.selectedTheme.colors.sucess
            )
            
        }
        .padding(.horizontal,Dimens.Padding.large)
        .padding(.vertical,Dimens.Padding.quiteLarge)
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
