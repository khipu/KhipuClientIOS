import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct MustContinueComponent: View {
    @StateObject var viewModel: KhipuViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    let operationMustContinue: OperationMustContinue
    
    var body: some View {
        VStack(alignment: .center, spacing: Dimens.Spacing.large) {
            VStack(alignment: .center, spacing: Dimens.Spacing.extraMedium) {
                Image(systemName: "info.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Dimens.Image.slightlyLarger, height: Dimens.Image.slightlyLarger)
                    .foregroundColor(themeManager.selectedTheme.colors.tertiary)
                Text(viewModel.uiState.translator.t("page.operationFailure.header.text.operation.task.finished"))
                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 24))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(themeManager.selectedTheme.colors.onSurface)
                Text((operationMustContinue.title)!)
                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(themeManager.selectedTheme.colors.onSurface)
                
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .top)
            
            FormWarning(text: operationMustContinue.body ?? "")
            InformationSection(operationMustContinue: operationMustContinue, khipuViewModel: viewModel, khipuUiState: viewModel.uiState)
            
            DetailSectionComponent(reason: "", operationId: operationMustContinue.operationID!,operationInfo: viewModel.uiState.operationInfo,viewModel: viewModel)

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
        .padding(.horizontal, Dimens.Padding.large)
        .padding(.vertical, Dimens.Padding.quiteLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(
          Rectangle()
            .inset(by: 0.5)
            .stroke(Color(red: 0.85, green: 0.85, blue: 0.85), lineWidth: 1)
        )
    }
}

@available(iOS 15.0, *)
struct InformationSection: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let operationMustContinue: OperationMustContinue
    let khipuViewModel: KhipuViewModel
    let khipuUiState: KhipuUiState
    
    var body: some View {
        VStack(alignment: .center, spacing:Dimens.Spacing.verySmall) {
            Text(khipuUiState.translator.t("page.operationMustContinue.share.description"))
                .foregroundStyle(themeManager.selectedTheme.colors.onSurface)
                .font(themeManager.selectedTheme.fonts.font(style: .medium, size: 14))
                .multilineTextAlignment(.center)
            
            Spacer().frame(height:Dimens.Spacing.extraMedium)
            
            CopyToClipboardLink(
                text: khipuUiState.operationInfo?.urls?.info ?? "",
                textToCopy: khipuUiState.operationInfo?.urls?.info ?? "",
                background:themeManager.selectedTheme.colors.onSecondaryContainer)
            
            Spacer().frame(height:Dimens.Spacing.extraMedium)

            
            if #available(iOS 16.0, *) {
                ShareLink(item: URL(string: khipuUiState.operationInfo?.urls?.info ?? "")!,
                          message: Text(khipuUiState.translator.t("page.operationMustContinue.share.link.body"))){
                    Label("Compartir", systemImage: "square.and.arrow.up")
                }
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius:Dimens.CornerRadius.moderatelySmall)
                .stroke(themeManager.selectedTheme.colors.onSurface, lineWidth: 0.3)
        )
    }
}




@available(iOS 15.0, *)
struct MustContinueComponent_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = KhipuViewModel()
        let urls = Urls(
            attachment: ["https://www.khipu.com"],
            cancel: "https://www.khipu.com",
            changePaymentMethod: "https://www.khipu.com",
            fallback: "https://www.khipu.com",
            image: "https://www.khipu.com",
            info: "https://www.khipu.com",
            manualTransfer: "https://www.khipu.com",
            urlsReturn: "https://www.khipu.com"
        )
        let uiState = KhipuUiState(operationInfo: OperationInfo(
                acceptManualTransfer: true,
                amount: "$ 1.000",
                body: "body",
                email: "khipu@khipu.com",
                merchant: nil,
                operationID: "operationID",
                subject: "Subject",
                type: MessageType.operationInfo,
                urls: urls,
                welcomeScreen: nil
            )
        )
        viewModel.uiState = uiState
        return MustContinueComponent(
            viewModel: viewModel,
            operationMustContinue: OperationMustContinue(
                type: MessageType.operationMustContinue,
                body: "body",
                events: nil,
                exitURL: "exitUrl",
                operationID: "operationID",
                resultMessage: "resultMessage",
                title: "Title",
                reason: nil
            )
        )
        .environmentObject(ThemeManager())
        .previewLayout(.sizeThatFits)
    }
}

/*

@available(iOS 15.0, *)
struct InformationSection_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = KhipuViewModel()
        let urls = Urls(
            attachment: ["https://www.khipu.com"],
            cancel: "https://www.khipu.com",
            changePaymentMethod: "https://www.khipu.com",
            fallback: "https://www.khipu.com",
            image: "https://www.khipu.com",
            info: "https://www.khipu.com",
            manualTransfer: "https://www.khipu.com",
            urlsReturn: "https://www.khipu.com"
        )
        let uiState = KhipuUiState(operationInfo: OperationInfo(
                acceptManualTransfer: true,
                amount: "$ 1.000",
                body: "body",
                email: "khipu@khipu.com",
                merchant: nil,
                operationID: "operationID",
                subject: "Subject",
                type: MessageType.operationInfo,
                urls: urls,
                welcomeScreen: nil
            )
        )
        let operationMustContinue = OperationMustContinue(
            type: MessageType.operationMustContinue,
            body: "body",
            events: nil,
            exitURL: "exitUrl",
            operationID: "operationID",
            resultMessage: "resultMessage",
            title: "Title",
            reason: nil
        )
        return InformationSection(
                    operationMustContinue: operationMustContinue,
                    khipuViewModel: viewModel,
                    khipuUiState: uiState
                )
                .environmentObject(ThemeManager())
                .previewLayout(.sizeThatFits)
                .padding()
    }
}
*/
