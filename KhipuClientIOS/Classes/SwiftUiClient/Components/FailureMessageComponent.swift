import SwiftUI
import KhenshinProtocol

@available(iOS 15.0.0, *)
struct FailureMessageComponent: View {
    let operationFailure: OperationFailure
    @ObservedObject public var viewModel: KhipuViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .center, spacing:Dimens.Spacing.large) {
            VStack(alignment: .center, spacing:Dimens.Spacing.medium) {
                
                Image(systemName: "info.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Dimens.Image.slightlyLarger, height: Dimens.Image.slightlyLarger)
                    .foregroundColor(themeManager.selectedTheme.colors.tertiary)
                
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .top)
            .cornerRadius(8)
            
            VStack(alignment: .center, spacing:Dimens.Spacing.medium) {
                Text(viewModel.uiState.translator.t("page.operationFailure.header.text.operation.task.finished"))
                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 24))
                    .multilineTextAlignment(.center)
                    .foregroundColor(themeManager.selectedTheme.colors.onBackground)
                
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .top)
            .cornerRadius(8)
            
            HStack(alignment: .center, spacing:Dimens.Spacing.medium) {
                Text((operationFailure.title)!)
                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(themeManager.selectedTheme.colors.onBackground)
            }
            .padding(.horizontal,Dimens.Padding.moderatelyLarge)
            .padding(.vertical, 0)
            .frame(maxWidth: .infinity, alignment: .center)
            
            FormWarning(text: operationFailure.body ?? "")
            Spacer().frame(height:Dimens.Spacing.large)
            
            DetailSectionComponent(reason: FieldUtils.getFailureReasonCode(reason: operationFailure.reason), operationId: operationFailure.operationID!,operationInfo: viewModel.uiState.operationInfo,viewModel: viewModel)
            
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
        .padding(.horizontal,Dimens.Padding.large)
        .padding(.vertical,Dimens.Padding.quiteLarge)
        .frame(maxWidth: .infinity, alignment: .top)
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
