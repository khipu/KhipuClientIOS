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
                
                let image = UIImage.fontAwesomeIcon(name: .infoCircle, style: .solid, textColor: UIColor(themeManager.selectedTheme.colors.tertiary), size: CGSize(width:Dimens.Image.slightlyLarger, height:Dimens.Image.slightlyLarger))
                Image(uiImage: image)
                
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .top)
            .cornerRadius(8)
            
            VStack(alignment: .center, spacing:Dimens.Spacing.medium) {
                Text(viewModel.uiState.translator.t("page.operationFailure.header.text.operation.task.finished"))
                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 24))
                    .multilineTextAlignment(.center)
                
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .top)
            .cornerRadius(8)
            
            HStack(alignment: .center, spacing:Dimens.Spacing.medium) {
                Text((operationFailure.title)!)
                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 16))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal,Dimens.Padding.moderatelyLarge)
            .padding(.vertical, 0)
            .frame(maxWidth: .infinity, alignment: .center)
            
            FormWarning(text: operationFailure.body ?? "")
            Spacer().frame(height:Dimens.Spacing.large)
            DetailSectionFailure(operationFailure: operationFailure,operationInfo: viewModel.uiState.operationInfo, viewModel: viewModel)
            
            MainButton(
                text: viewModel.uiState.translator.t("default.end.and.go.back"),
                enabled: true,
                onClick: {
                    viewModel.uiState.returnToApp = true
                },
                foregroundColor: themeManager.selectedTheme.colors.onTertiary,
                backgroundColor: themeManager.selectedTheme.colors.tertiary
            )
            
            MainButton(
                text: viewModel.uiState.translator.t("default.user.other.bank"),
                enabled: true,
                onClick: {
                    viewModel.uiState.returnToApp = true                },
                foregroundColor: .black,
                backgroundColor: .white
            ).cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius:Dimens.CornerRadius.extraSmall)
                        .inset(by: 0.5)
                        .stroke(themeManager.selectedTheme.colors.labelForeground, lineWidth: 1))
        }
        .padding(.horizontal,Dimens.Padding.large)
        .padding(.vertical,Dimens.Padding.quiteLarge)
        .frame(maxWidth: .infinity, alignment: .top)
    }
    
}

@available(iOS 15.0.0, *)
struct DetailSectionFailure: View {
    var operationFailure: OperationFailure
    var operationInfo: OperationInfo?
    @ObservedObject public var viewModel: KhipuViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        
        VStack(alignment: .center, spacing:Dimens.Spacing.large) {
            Text(viewModel.uiState.translator.t("default.detail.label"))
                .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 16))
            
            DetailItemFailure(label: viewModel.uiState.translator.t("default.amount.label"), value: operationInfo?.amount ?? "")
            
            DetailItemFailure(label: viewModel.uiState.translator.t("default.merchant.label"), value:operationInfo?.merchant?.name ?? "")
            DashedLine()
            DetailItemFailure(label: viewModel.uiState.translator.t("default.operation.code.short.label"), value: FieldUtils.formatOperationId(operationId: operationFailure.operationID)+" "+FieldUtils.getFailureReasonCode(reason: operationFailure.reason),shouldCopyValue: true)
        }
        .padding(Dimens.Padding.large)
        .frame(maxWidth: .infinity, alignment: .top)
        .cornerRadius(Dimens.CornerRadius.moderatelySmall)
    }
}

@available(iOS 15.0.0, *)
struct DetailItemFailure: View {
    var label: String
    var value: String
    var shouldCopyValue: Bool = false
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            Text(label)
                .font(themeManager.selectedTheme.fonts.font(style: .medium, size: 14))
                .foregroundColor(themeManager.selectedTheme.colors.labelForeground)
            Spacer()
            if !shouldCopyValue {
                Text(value)
                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 14))
                
            } else {
                CopyToClipboardOperationId(text: value, textToCopy: FieldUtils.formatOperationId(operationId:value), background:themeManager.selectedTheme.colors.onSecondaryContainer)
            }
        }
        .padding(.vertical,Dimens.Padding.verySmall)
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

@available(iOS 15.0, *)
struct DetailSectionFailure_Previews: PreviewProvider {
    static var previews: some View {
        DetailSectionFailure(
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


@available(iOS 15.0, *)
struct DetailItemFailure_Previews: PreviewProvider {
    static var previews: some View {
        DetailItemFailure(
            label: "Label",
            value: "Value"
        )
        .environmentObject(ThemeManager())
        .padding()
    }
}
