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
            HStack(alignment: .center, spacing: themeManager.selectedTheme.dimens.verySmall) {
                
                Text(text)
                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 14))
                
                let image = UIImage.fontAwesomeIcon(name: .copy, style: .solid, textColor: UIColor(.white), size: CGSize(width: themeManager.selectedTheme.dimens.large, height: themeManager.selectedTheme.dimens.large))
                Image(uiImage: image)
            }
        }
        .padding(.horizontal, themeManager.selectedTheme.dimens.medium)
        .padding(.vertical, 0)
        .background(themeManager.selectedTheme.colors.onSecondaryContainer)
        .cornerRadius(themeManager.selectedTheme.dimens.extraSmall)
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
            HStack(alignment: .center, spacing: themeManager.selectedTheme.dimens.verySmall) {
                Text(text)
                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 14))
                
                let image = UIImage.fontAwesomeIcon(name: .copy, style: .solid, textColor: UIColor(.white), size: CGSize(width: themeManager.selectedTheme.dimens.large, height: themeManager.selectedTheme.dimens.large))
                Image(uiImage: image)
            }
            .padding(.horizontal, themeManager.selectedTheme.dimens.medium)
            .padding(.vertical, 0)
            .background(themeManager.selectedTheme.colors.onSecondaryContainer)
            .cornerRadius(themeManager.selectedTheme.dimens.extraSmall)        }
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
