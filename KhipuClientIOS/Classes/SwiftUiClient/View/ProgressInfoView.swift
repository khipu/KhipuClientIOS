import Foundation
import SwiftUI

@available(iOS 15.0, *)
struct ProgressInfoView: View {
    var message: String
    var subtitle: String = ""
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        VStack(spacing: Dimens.quiteLarge) {
            VStack(spacing: Dimens.veryMedium) {
                Text(message)
                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 20))
                    .foregroundColor(themeManager.selectedTheme.colors.onBackground)
                    .tracking(0.15)
                    .lineSpacing(12)

                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(themeManager.selectedTheme.fonts.font(style: .regular, size: 16))
                        .foregroundColor(themeManager.selectedTheme.colors.info)
                        .tracking(0.15)
                }
            }

            ZStack {
                CircularProgressView()
                    .frame(width: 104, height: 104)

                Image(systemName: "lock.fill")
                    .font(.system(size: 24))
                    .foregroundColor(themeManager.selectedTheme.colors.onSurfaceVariant)
            }
            .frame(height: 150)
        }
        .frame(maxWidth: 350)
        .padding(.horizontal, Dimens.large)
        .padding(.vertical, Dimens.quiteLarge)
    }
}

@available(iOS 15.0, *)
struct ProgressInfoView_Previews: PreviewProvider {
    static var previews: some View {
        return ProgressInfoView(message: "Progress info message")
            .environmentObject(ThemeManager())
            .previewLayout(.sizeThatFits)
    }
}
