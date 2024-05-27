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
                    .font(.system(size: themeManager.selectedTheme.dimens.veryMedium))
                Image(systemName: "doc.on.doc")
                    .resizable()
                    .frame(width: themeManager.selectedTheme.dimens.large, height: themeManager.selectedTheme.dimens.large)
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
