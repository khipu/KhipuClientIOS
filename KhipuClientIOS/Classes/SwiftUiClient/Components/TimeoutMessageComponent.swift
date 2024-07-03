import SwiftUI
import KhenshinProtocol


@available(iOS 15.0.0, *)
struct TimeoutMessageComponent: View {
    let operationFailure: OperationFailure
    @ObservedObject public var viewModel: KhipuViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text(viewModel.uiState.translator.t("page.timeout.session.closed"))
                .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 24))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .top)
            
            VStack(alignment: .center, spacing: 10) {
                FormWarning(text: viewModel.uiState.translator.t("page.timeout.try.again"))
                
                VStack(alignment: .center, spacing: 20) {
                    VStack(alignment: .center, spacing: 20) {
                        let image = UIImage.fontAwesomeIcon(name: .clock, style: .light, textColor: UIColor(themeManager.selectedTheme.colors.labelForeground), size: CGSize(width: 100, height: 100))
                        Image(uiImage: image)
                        HStack(alignment: .center, spacing: 10) {
                            Text(viewModel.uiState.translator.t("page.timeout.end"))
                                .foregroundColor(themeManager.selectedTheme.colors.labelForeground)
                                .font(themeManager.selectedTheme.fonts.font(style: .medium, size: 16))
                                .multilineTextAlignment(.center)
                        }
                        .padding(10)
                        .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 48, alignment: .center)
                    }
                    .padding(.horizontal, 0)
                    .padding(.vertical, 50)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .cornerRadius(6)
                    
                    Text(viewModel.uiState.translator.t("default.operation.code.label"))
                        .foregroundColor(themeManager.selectedTheme.colors.labelForeground)
                        .font(themeManager.selectedTheme.fonts.font(style: .regular, size: 14))
                        .multilineTextAlignment(.center)
                    CopyToClipboardOperationId(
                        text: operationFailure.operationID ?? "",
                        textToCopy: FieldUtils.formatOperationId(operationId: operationFailure.operationID ?? ""),
                        background:themeManager.selectedTheme.colors.onSecondaryContainer)
                    
                    
                    MainButton(
                        text: viewModel.uiState.translator.t("page.redirectManual.redirecting"),
                        enabled: true,
                        onClick: {
                            viewModel.uiState.returnToApp = true
                        },
                        foregroundColor: themeManager.selectedTheme.colors.onTertiary,
                        backgroundColor: themeManager.selectedTheme.colors.tertiary
                    )
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 32)
                .frame(maxWidth: .infinity, alignment: .top)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 32)
            .frame(maxWidth: .infinity, alignment: .top)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 32)
        .frame(maxWidth: .infinity, alignment: .top)
    }
    
}

@available(iOS 15.0, *)
struct TimeoutMessageComponent_Previews: PreviewProvider{
    static var previews: some View{
        return TimeoutMessageComponent(operationFailure:
                                        OperationFailure(
                                            type: MessageType.operationWarning,
                                            body: "body",
                                            events: nil,
                                            exitURL: "exitUrl",
                                            operationID: "operationID",
                                            resultMessage: "resultMessage",
                                            title: "Title",
                                            reason: FailureReasonType.formTimeout
                                        ), viewModel: KhipuViewModel()
        )
        .environmentObject(ThemeManager())
        .padding()
    }
}
