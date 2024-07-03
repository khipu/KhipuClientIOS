import SwiftUI

@available(iOS 15, *)
struct OptionImage: View {
    var image: String?
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        if !(image?.isEmpty ?? true) {
            AsyncImage(url: URL(string: image ?? "")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:themeManager.selectedTheme.dimens.slightlyLarger, height: themeManager.selectedTheme.dimens.slightlyLarger)
                        .clipShape(Circle())
                } else if phase.error != nil {
                    Color.red
                        .frame(width: themeManager.selectedTheme.dimens.slightlyLarger, height: themeManager.selectedTheme.dimens.slightlyLarger)
                        .clipShape(Circle())
                } else {
                    Color.gray
                        .frame(width: themeManager.selectedTheme.dimens.slightlyLarger, height: themeManager.selectedTheme.dimens.slightlyLarger)
                        .clipShape(Circle())
                }
            }
        }
    }
}

@available(iOS 15, *)
struct OptionImage_Previews: PreviewProvider {
    static var previews: some View {
        
        return OptionImage(image: "https://s3.amazonaws.com/static.khipu.com/logos/bancos/chile/demobank-icon.png")
            .environmentObject(ThemeManager())
    }
}
