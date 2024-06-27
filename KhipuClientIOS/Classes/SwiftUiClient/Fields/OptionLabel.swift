import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct OptionLabel: View  {
var image: String?
var text: String?

@EnvironmentObject private var themeManager: ThemeManager

var body: some View {
    HStack {
        OptionImage(image: image)
        Text(text ?? "")
            .font(themeManager.selectedTheme.fonts.bold14)
            .foregroundColor(themeManager.selectedTheme.colors.onSurface)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
    .background(themeManager.selectedTheme.colors.background)
    }
}

@available(iOS 15.0, *)
struct OptionLabel_Previews: PreviewProvider {
static var previews: some View {
    
    return VStack {
        OptionLabel(
            image: "https://s3.amazonaws.com/static.khipu.com/logos/bancos/chile/demobank-icon.png",
            text: "Hello"
        )
        
        OptionLabel(
            image: "https://s3.amazonaws.com/static.khipu.com/logos/bancos/chile/demobank-icon.png",
            text: "Bye"
        )
        
    }
    .padding()
    .environmentObject(ThemeManager())
}
}
