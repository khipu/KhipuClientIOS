
import Foundation
import SwiftUI
import KhenshinProtocol

@available(iOS 15.0.0, *)
struct HeaderComponent: View {
    @ObservedObject var viewModel: KhipuViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showMerchantDialog = false
    
    var body: some View {
        if (viewModel.uiState.operationInfo?.merchant) != nil {
            VStack(spacing: 0) {
                headerContent
                Spacer().frame(height: themeManager.selectedTheme.dimens.extraSmall)
                Divider()
                Spacer().frame(height: themeManager.selectedTheme.dimens.extraSmall)
                footerContent
                Spacer().frame(height: themeManager.selectedTheme.dimens.extraSmall)
                Divider()
            }
            .sheet(isPresented: $showMerchantDialog) {
                MerchantDialogComponent(
                    onDismissRequest: { showMerchantDialog = false },
                    translator: viewModel.uiState.translator,
                    merchant: (viewModel.uiState.operationInfo?.merchant?.name)!,
                    subject: (viewModel.uiState.operationInfo?.subject)! ,
                    description:(viewModel.uiState.operationInfo?.body)!,
                    amount: (viewModel.uiState.operationInfo?.amount)!
                )
            }
        } else {
            SkeletonHeaderComponent()
        }
    }
    
    private var headerContent: some View {
        HStack() {
            AsyncImage(url: URL(string: viewModel.uiState.operationInfo?.merchant?.logo ?? "")) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            } placeholder: {
                ProgressView()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.uiState.operationInfo?.merchant?.name ?? "")
                    .font(themeManager.selectedTheme.fonts.semiBold14)
                    .foregroundColor(themeManager.selectedTheme.colors.labelForeground)
                
                Text(viewModel.uiState.operationInfo?.subject ?? "")
                    .font(themeManager.selectedTheme.fonts.semiBold14)
                    .foregroundColor(Color.primary)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(viewModel.uiState.translator.t("header.amount", default: "").uppercased())
                    .font(themeManager.selectedTheme.fonts.medium10)
                    .foregroundColor(themeManager.selectedTheme.colors.labelForeground)
                
                Text(viewModel.uiState.operationInfo?.amount ?? "")
                    .font(themeManager.selectedTheme.fonts.bold20)
                    .foregroundColor(Color.primary)
                
            }
        }.padding(.horizontal, themeManager.selectedTheme.dimens.large)
            .padding(.vertical,themeManager.selectedTheme.dimens.veryMedium)
    }
    
    private var footerContent: some View {
        HStack {
            formattedCode()
                .font(themeManager.selectedTheme.fonts.medium10)
            
            Spacer()
            
            Button(action: { showMerchantDialog = true }) {
                Text("Ver detalle")
                    .font(themeManager.selectedTheme.fonts.semiBold14)
                    .foregroundColor(themeManager.selectedTheme.colors.secondary)
                    .bold()
            }
            
        }.padding(.horizontal, themeManager.selectedTheme.dimens.large)
        
    }
    private func formattedCode() -> Text {
        var text = Text("")
        text = text + Text(viewModel.uiState.translator.t("header.code.label", default: "").uppercased()).foregroundColor(themeManager.selectedTheme.colors.labelForeground)
        text = text + Text(" • \(viewModel.uiState.operationInfo?.operationID ?? "")").foregroundColor(themeManager.selectedTheme.colors.onSurface)
        
        return text
    }
}

@available(iOS 15.0.0, *)
struct HeaderComponent_Previews: PreviewProvider {
    static var previews: some View {
        let uiState = KhipuUiState(operationInfo: OperationInfo(
            acceptManualTransfer: true,
            amount: "$ 1.000",
            body: "body",
            email: "khipu@khipu.com",
            merchant:
                Merchant(
                    logo: "",
                    name: "Merchant"
                ),
            operationID: "operationID",
            subject: "Subject",
            type: MessageType.operationInfo,
            urls: nil,
            welcomeScreen: nil
        )
        )
        let viewModel = KhipuViewModel()
        viewModel.uiState = uiState
        return VStack{
            Text("Skeleton:")
            HeaderComponent(
                viewModel: KhipuViewModel()
            )
            .environmentObject(ThemeManager())
            .padding()
            Text("Loaded:")
            HeaderComponent(
                viewModel: viewModel
            )
            .environmentObject(ThemeManager())
            .padding()
        }
    }
}
