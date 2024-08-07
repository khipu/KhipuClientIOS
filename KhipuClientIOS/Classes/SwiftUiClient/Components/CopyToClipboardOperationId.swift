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
            HStack(alignment: .center, spacing:Dimens.Spacing.verySmall) {
                Text(text)
                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 14))
                    .foregroundColor(themeManager.selectedTheme.colors.secondary)
                Image(systemName: "doc.on.doc")
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .frame(width: Dimens.Image.veryMedium, height: Dimens.Image.veryMedium)
                      .foregroundColor(themeManager.selectedTheme.colors.secondary)
            }
        }
        .padding(.horizontal,Dimens.Padding.medium)
        .padding(.vertical, 0)
        .cornerRadius(Dimens.CornerRadius.extraSmall)
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
            HStack(alignment: .center, spacing:Dimens.Spacing.verySmall) {
                Text(text)
                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 14))
                    .foregroundColor(themeManager.selectedTheme.colors.secondary)
              Image(systemName: "doc.on.doc")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Dimens.Image.veryMedium, height: Dimens.Image.veryMedium)
                    .foregroundColor(themeManager.selectedTheme.colors.secondary)
            }
            .padding(.horizontal,Dimens.Padding.medium)
            .padding(.vertical, 0)
            .cornerRadius(Dimens.CornerRadius.extraSmall)        }
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
