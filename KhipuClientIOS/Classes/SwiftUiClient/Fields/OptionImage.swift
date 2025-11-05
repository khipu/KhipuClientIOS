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
                        .frame(width: Dimens.Image.bankLogo, height: Dimens.Image.bankLogo)
                } else if phase.error != nil {
                    Color.red
                        .frame(width: Dimens.Image.bankLogo, height: Dimens.Image.bankLogo)
                } else {
                    Color.gray
                        .frame(width: Dimens.Image.bankLogo, height: Dimens.Image.bankLogo)
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
