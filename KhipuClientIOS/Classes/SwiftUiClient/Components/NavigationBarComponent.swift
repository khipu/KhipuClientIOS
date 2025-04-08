import SwiftUI

@available(iOS 15.0, *)
struct NavigationBarComponent: View {
    var title: String?
    var imageName: String?
    var imageUrl: String?
    var imageScale: CGFloat
    var translator: KhipuTranslator
    var returnToApp: () -> Void
    @State private var isConfirmingClose = false
    @EnvironmentObject private var themeManager: ThemeManager
    
    init(title: String? = nil, imageName: String? = nil, imageUrl: String? = nil, imageScale: CGFloat? = nil, translator: KhipuTranslator, returnToApp: @escaping () -> Void, isConfirmingClose: Bool = false) {
        self.title = title
        self.imageName = imageName
        self.imageUrl = imageUrl
        self.imageScale = imageScale ?? 1.0
        self.translator = translator
        self.returnToApp = returnToApp
        self.isConfirmingClose = isConfirmingClose
    }
    
    var body: some View {
        HStack {
            Spacer().frame(width: 50)
            Spacer()
            if (imageUrl != nil) {
                GeometryReader { geometry in
                    AsyncImage(url: URL(string: imageUrl!)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: geometry.size.width * self.imageScale, maxHeight: geometry.size.height * self.imageScale)
                            
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: geometry.size.width * 1)
                    //.aspectRatio(contentMode: .fit)
                }
            } else if (imageName != nil) {
                GeometryReader { geometry in
                    ZStack {
                        Image(imageName!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: geometry.size.width * self.imageScale, maxHeight: geometry.size.height * self.imageScale)
                            
                            
                    }
                    //.aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width, height:  geometry.size.height)
                    
                }
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
            .confirmationDialog(translator.t("modal.abortOperation.title"),
                                isPresented: $isConfirmingClose,
                                titleVisibility: .visible
            ) {
                Button(translator.t("modal.abortOperation.cancel.button"), role: .destructive){
                    returnToApp()
                }
                Button(translator.t("modal.abortOperation.continue.button"), role: .cancel) {
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
        return NavigationBarComponent(imageName: "header_image", imageUrl: nil, translator: MockDataGenerator.createTranslator(), returnToApp: {})        .environmentObject(ThemeManager())
        
    }
}

@available(iOS 15.0, *)
struct NavigationBarComponentWithImage_Previews: PreviewProvider {
    static var previews: some View {
        return NavigationBarComponent(title:"Title",imageName: nil,
                                      imageUrl: "https://s3.amazonaws.com/static.khipu.com/buttons/2024/200x75-black.png", imageScale: 0.7, translator: MockDataGenerator.createTranslator(), returnToApp: {})        .environmentObject(ThemeManager())
        
    }
}
