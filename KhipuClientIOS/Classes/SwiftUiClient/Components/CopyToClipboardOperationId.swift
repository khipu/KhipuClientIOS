import SwiftUI

@available(iOS 15.0, *)
struct CopyToClipboardOperationId: View {
    var text: String
    var textToCopy: String
    var background: Color
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Button(action: {
            UIPasteboard.general.string = textToCopy
        }) {
            HStack {
                Text(text)
                    .font(themeManager.selectedTheme.fonts.semiBold14)
                
                let image = UIImage.fontAwesomeIcon(name: .copy, style: .solid, textColor: UIColor(.white), size: CGSize(width: 20, height: 20))
                Image(uiImage: image)
            }
            .padding(.all, 8)
            .background(background)
            .cornerRadius(themeManager.selectedTheme.dimens.extraSmall)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

@available(iOS 15.0, *)
struct CopyToClipboardLink: View {
    var text: String
    var textToCopy: String
    var background: Color
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Button(action: {
            UIPasteboard.general.string = textToCopy
        }) {
            HStack {
                Text(text)
                    .font(.system(size: themeManager.selectedTheme.dimens.extraMedium))
                Image(systemName: "doc.on.doc")
                    .resizable()
                    .frame(width: themeManager.selectedTheme.dimens.large, height: themeManager.selectedTheme.dimens.large)
            }
            .padding()
            .background(background)
            .cornerRadius(themeManager.selectedTheme.dimens.extraSmall)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

@available(iOS 15.0, *)
struct CopyToClipboardOperationId_Previews: PreviewProvider {
    static var previews: some View {
        CopyToClipboardOperationId(
            text: "Copy",
            textToCopy: "Copied text",
            background: Color(hexString: "#a6c6e5")!
        )
        .environmentObject(ThemeManager())
        .padding()
    }
}


@available(iOS 15.0, *)
struct CopyToClipboardLink_Previews: PreviewProvider {
    static var previews: some View {
        CopyToClipboardLink(
            text: "Copy", 
            textToCopy: "Copied text",
            background: Color(hexString: "#a6c6e5")!
        )
        .environmentObject(ThemeManager())
        .padding()
    }
}
