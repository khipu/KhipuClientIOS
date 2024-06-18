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
                .font(.system(size: 16))
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
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
