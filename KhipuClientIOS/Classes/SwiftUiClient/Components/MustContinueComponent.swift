//
//  MustContinueComponent.swift
//  KhipuClientIOS
//
//  Created by Mauricio Castillo on 28-05-24.
//

import SwiftUI
import KhenshinProtocol

@available(iOS 14.0, *)
struct MustContinueComponent: View {
    @StateObject private var khipuViewModel: KhipuViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    let operationMustContinue: OperationMustContinue
    
    var body: some View {
        VStack(alignment: .center, spacing: themeManager.selectedTheme.dimens.extraSmall) {
            Image(systemName: "clock.fill")
                .foregroundColor(themeManager.selectedTheme.colors.tertiary)
                .font(.system(size: themeManager.selectedTheme.dimens.extraLarge))
            
            Text(khipuViewModel.uiState.translator.t("page.operationWarning.failure.after.notify.pre.header"))
                .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Text(operationMustContinue.title ?? "")
                .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                .font(.title2)
                .multilineTextAlignment(.center)
            
            FormWarning(text: operationMustContinue.body ?? "")
            
            Spacer(minLength: themeManager.selectedTheme.dimens.moderatelyLarge)
            InformationSection(operationMustContinue: operationMustContinue, khipuViewModel: khipuViewModel, khipuUiState: khipuViewModel.uiState)
            Spacer(minLength: themeManager.selectedTheme.dimens.moderatelyLarge)
            DetailSection(operationMustContinue: operationMustContinue, khipuViewModel: khipuViewModel)
            Spacer(minLength: themeManager.selectedTheme.dimens.moderatelyLarge)
            MainButton(
                text: khipuViewModel.uiState.translator.t("default.end.and.go.back"),
                enabled: true,
                onClick: {
                    khipuViewModel.uiState.returnToApp = true
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

@available(iOS 13.0, *)
struct InformationSection: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let operationMustContinue: OperationMustContinue
    let khipuViewModel: KhipuViewModel
    let khipuUiState: KhipuUiState
    
    var body: some View {
        VStack(alignment: .center, spacing: themeManager.selectedTheme.dimens.verySmall) {
            
            ZStack {
                RoundedRectangle(cornerRadius: themeManager.selectedTheme.dimens.extraSmall)
                    .fill(themeManager.selectedTheme.colors.surface)
                    .border(width: themeManager.selectedTheme.dimens.none, edges: .all, color: themeManager.selectedTheme.colors.onTertiary)
                    .padding(themeManager.selectedTheme.dimens.veryLarge)
                
                VStack(alignment: .center) {
                    Text(khipuUiState.translator.t("page.operationMustContinue.share.description"))
                        .foregroundColor(themeManager.selectedTheme.colors.surface)
                        .font(.system(size: themeManager.selectedTheme.dimens.veryMedium))
                        .multilineTextAlignment(.center)
                    
                    Spacer().frame(height: themeManager.selectedTheme.dimens.moderatelyLarge)
                    
                    CopyToClipboardLink(
                        text: khipuUiState.operationInfo?.urls?.info ?? "",
                        textToCopy: khipuUiState.operationInfo?.urls?.info ?? "",
                        background: themeManager.selectedTheme.colors.secondary
                    )
                    
                    Spacer().frame(height: themeManager.selectedTheme.dimens.moderatelyLarge)
                    
                    InteractiveIconsComponent(khipuViewModel: khipuViewModel)
                }
            }
        }
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
                CopyToClipboardOperationId(text: formatOperationId(value), textToCopy: value, background: Color(uiColor: .secondarySystemBackground))
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
