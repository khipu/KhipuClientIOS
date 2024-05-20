import SwiftUI

@available(iOS 15.0, *)
struct CopyToClipboardOperationId: View {
    var text: String
    var textToCopy: String
    var background: Color

    var body: some View {
        Button(action: {
            UIPasteboard.general.string = textToCopy
        }) {
            HStack {
                Text(text)
                    .font(.system(size: Dimens.veryMedium))
                Image(systemName: "doc.on.doc")
                    .resizable()
                    .frame(width: Dimens.large, height: Dimens.large)
            }
            .padding(.all, 8)
            .background(background)
            .cornerRadius(Dimens.extraSmall)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

@available(iOS 15.0, *)
struct CopyToClipboardLink: View {
    var text: String
    var textToCopy: String
    var background: Color

    var body: some View {
        Button(action: {
            UIPasteboard.general.string = textToCopy
        }) {
            HStack {
                Text(text)
                    .font(.system(size: Dimens.extraMedium))
                Image(systemName: "doc.on.doc")
                    .resizable()
                    .frame(width: Dimens.large, height: Dimens.large)
            }
            .padding()
            .background(background)
            .cornerRadius(Dimens.extraSmall)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
