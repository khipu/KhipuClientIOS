
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
                Spacer().frame(height: themeManager.selectedTheme.dimens.extraSmall)
                headerContent
                Spacer().frame(height: themeManager.selectedTheme.dimens.extraSmall)
                Divider()
                Spacer().frame(height: themeManager.selectedTheme.dimens.extraSmall)
                footerContent
                Spacer().frame(height: themeManager.selectedTheme.dimens.extraSmall)
                Divider()
            }
            .padding(.horizontal,  themeManager.selectedTheme.dimens.extraSmall)
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
        HStack(spacing: 8) {
            AsyncImage(url: URL(string: viewModel.uiState.operationInfo?.merchant?.logo ?? "")) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            } placeholder: {
                ProgressView()
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.uiState.operationInfo?.merchant?.name ?? "")
                    .font(.footnote)
                    .foregroundColor(Color.gray)

                Text(viewModel.uiState.operationInfo?.subject ?? "")
                    .font(.footnote)
                    .foregroundColor(Color.primary)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(viewModel.uiState.translator.t("header.amount", default: "").uppercased())
                    .font(.footnote)
                    .foregroundColor(Color.gray)

                Text(viewModel.uiState.operationInfo?.amount ?? "")
                    .font(.title3)
                    .bold()
            }
        }
    }

    private var footerContent: some View {
        HStack {
            formattedCode()
                .font(.caption)

            Spacer()

            Button(action: { showMerchantDialog = true }) {
                Text("Ver detalle")
                    .font(.footnote)
                    .foregroundColor(.blue)
                    .bold()
            }
        }
    }
    private func formattedCode() -> Text {
        var text = Text("")
        text = text + Text(viewModel.uiState.translator.t("header.code.label", default: "").uppercased()).foregroundColor(Color.gray)
        text = text + Text(" • \(viewModel.uiState.operationInfo?.operationID ?? "")").foregroundColor(Color.primary)

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
