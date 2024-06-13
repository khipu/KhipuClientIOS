import SwiftUI

@available(iOS 15.0, *)
struct NavigationBarComponent: View {
    var title: String?
    var imageName: String?
    var imageUrl: String?
    @State private var isConfirmingClose = false
    @ObservedObject public var viewModel: KhipuViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            Spacer().frame(width: 50)
            Spacer()
            if (imageUrl != nil) {
                AsyncImage(url: URL(string: imageUrl!)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
            } else if (imageName != nil) {
                Image(imageName!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Text(title ?? appName()).foregroundStyle(themeManager.selectedTheme.colors.onTopBarContainer).font(.title3)
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

@available(iOS 15.0, *)
struct NavigationBarComponent_Previews: PreviewProvider {
    static var previews: some View {
        return NavigationBarComponent(
            title: "Title",
            imageName: nil,
            viewModel: KhipuViewModel()
        )
        .environmentObject(ThemeManager())
    }
}

@available(iOS 15.0, *)
struct NavigationBarComponentWithImage_Previews: PreviewProvider {
    static var previews: some View {
        return NavigationBarComponent(
            title: "Title",
            imageName: nil, 
            imageUrl: "https://s3.amazonaws.com/static.khipu.com/buttons/2024/200x75-black.png",
            viewModel: KhipuViewModel()
        )
        .environmentObject(ThemeManager())
    }
}
