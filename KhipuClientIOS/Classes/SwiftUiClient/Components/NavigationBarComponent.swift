import SwiftUI

@available(iOS 15.0, *)
struct NvigationBarComponent: View {
    var title: String?
    var imageName: String?
    @State private var isConfirmingClose = false
    @ObservedObject public var viewModel: KhipuViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            Spacer().frame(width: 50)
            Spacer()
            if (imageName == nil) {
                Text(title ?? appName()).foregroundStyle(themeManager.selectedTheme.colors.onTopBarContainer).font(.title3)
            } else {
                Image(imageName!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            Spacer()
            Button {
                isConfirmingClose = true
            } label: {
                Image(systemName: "xmark").tint(themeManager.selectedTheme.colors.onTopBarContainer)
            }
            .padding()
            .confirmationDialog(
                viewModel.uiState.translator.t("modal.abortOperation.title"),
                isPresented: $isConfirmingClose,
                titleVisibility: .visible
            ) {
                Button(viewModel.uiState.translator.t("modal.abortOperation.cancel.button"), role: .destructive) {
                    viewModel.uiState.returnToApp = true
                }
                Button(viewModel.uiState.translator.t("modal.abortOperation.continue.button"), role: .cancel) {
                    isConfirmingClose = false
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
        .background(themeManager.selectedTheme.colors.topBarContainer)
    }
}
