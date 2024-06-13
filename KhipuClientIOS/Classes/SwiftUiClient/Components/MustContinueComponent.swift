//
//  MustContinueComponent.swift
//  KhipuClientIOS
//
//  Created by Mauricio Castillo on 28-05-24.
//

import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct MustContinueComponent: View {
    @StateObject var viewModel: KhipuViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    let operationMustContinue: OperationMustContinue
    
    var body: some View {
        VStack(alignment: .center, spacing: themeManager.selectedTheme.dimens.extraSmall) {
            Image(systemName: "clock.fill")
                .foregroundColor(themeManager.selectedTheme.colors.tertiary)
                .font(.system(size: themeManager.selectedTheme.dimens.larger))
            
            Text(viewModel.uiState.translator.t("page.operationWarning.failure.after.notify.pre.header"))
                .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                .font(.system(size: themeManager.selectedTheme.dimens.large))
                .multilineTextAlignment(.center)
            
            Text(operationMustContinue.title ?? "")
                .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                .font(.system(size: themeManager.selectedTheme.dimens.large))
                .multilineTextAlignment(.center)
            
            FormWarning(text: operationMustContinue.body ?? "")
            
            Spacer(minLength: themeManager.selectedTheme.dimens.veryMedium)
            InformationSection(operationMustContinue: operationMustContinue, khipuViewModel: viewModel, khipuUiState: viewModel.uiState)
            Spacer(minLength: themeManager.selectedTheme.dimens.veryMedium)
            DetailSection(operationMustContinue: operationMustContinue)
            Spacer(minLength: themeManager.selectedTheme.dimens.veryMedium)
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
        .padding(themeManager.selectedTheme.dimens.extraMedium)
        .background(themeManager.selectedTheme.colors.surface)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

@available(iOS 15.0, *)
struct InformationSection: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let operationMustContinue: OperationMustContinue
    let khipuViewModel: KhipuViewModel
    let khipuUiState: KhipuUiState
    
    var body: some View {
        VStack(alignment: .center, spacing: themeManager.selectedTheme.dimens.verySmall) {
            Text(khipuUiState.translator.t("page.operationMustContinue.share.description"))
                .foregroundColor(themeManager.selectedTheme.colors.onSurfaceVariant)
                .font(.system(size: themeManager.selectedTheme.dimens.extraMedium))
                .multilineTextAlignment(.center)
            
            Spacer().frame(height: themeManager.selectedTheme.dimens.extraMedium)
            
            CopyToClipboardLink(
                text: khipuUiState.operationInfo?.urls?.info ?? "",
                textToCopy: khipuUiState.operationInfo?.urls?.info ?? "",
                background: themeManager.selectedTheme.colors.secondaryContainer
            )
            
            Spacer().frame(height: themeManager.selectedTheme.dimens.extraMedium)
            
            if #available(iOS 16.0, *) {
                ShareLink(item: URL(string: khipuUiState.operationInfo?.urls?.info ?? "")!,
                          message: Text(khipuUiState.translator.t("page.operationMustContinue.share.link.body"))){
                    Label("Compartir", systemImage: "square.and.arrow.up")
                }
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: themeManager.selectedTheme.dimens.moderatelySmall)
                .stroke(themeManager.selectedTheme.colors.onSurface, lineWidth: 0.3)
        )
    }
}

@available(iOS 15.0, *)
struct DetailItemMustContinue: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let label: String
    let value: String
    let shouldCopyValue: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Text(label)
                .foregroundColor(themeManager.selectedTheme.colors.onSurfaceVariant)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
            if !shouldCopyValue {
                Text(value)
                    .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                    .font(.body)
            } else {
                CopyToClipboardOperationId(text: formatOperationId(value), textToCopy: value, background: themeManager.selectedTheme.colors.secondaryContainer)
            }
        }
        .padding(.vertical, 4)
        .frame(maxWidth: .infinity)
    }
    
    private func formatOperationId(_ value: String) -> String {
        // Implement your custom formatting logic here
        return value
    }
}

@available(iOS 15.0, *)
struct DetailSection: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @StateObject private var khipuViewModel: KhipuViewModel
    let operationMustContinue: OperationMustContinue
    
    init(operationMustContinue: OperationMustContinue) {
        self._khipuViewModel = StateObject(wrappedValue: KhipuViewModel())
        self.operationMustContinue = operationMustContinue
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: themeManager.selectedTheme.dimens.verySmall) {
            Text(khipuViewModel.uiState.translator.t("default.detail.label"))
                .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                .font(Font.body.bold())
            
            DetailItemMustContinue(
                label: khipuViewModel.uiState.translator.t("default.amount.label"),
                value: khipuViewModel.uiState.operationInfo?.amount ?? "",
                shouldCopyValue: false
            )
            
            DetailItemMustContinue(
                label: khipuViewModel.uiState.translator.t("default.merchant.label"),
                value: khipuViewModel.uiState.operationInfo?.merchant?.name ?? "",
                shouldCopyValue: false
            )
            
            DashedLine()
            
            DetailItemMustContinue(
                label: khipuViewModel.uiState.translator.t("default.operation.code.short.label"),
                value: operationMustContinue.operationID ?? "",
                shouldCopyValue: true
            )
        }
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


@available(iOS 15.0, *)
struct DetailItemMustContinue_Previews: PreviewProvider {
    static var previews: some View {
        return DetailItemMustContinue(
            label: "Label",
            value: "Value",
            shouldCopyValue: true
        )
        .environmentObject(ThemeManager())
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

@available(iOS 15.0, *)
struct DetailSection_Previews: PreviewProvider {
    static var previews: some View {
        return DetailSection(
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
        .padding()
    }
}
