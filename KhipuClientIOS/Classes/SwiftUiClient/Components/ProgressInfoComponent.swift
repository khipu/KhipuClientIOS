import Foundation
import SwiftUI

@available(iOS 15.0, *)
struct ProgressInfoComponent: View {
    var message: String
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                CircularProgressView()
                    .frame(width: themeManager.selectedTheme.dimens.extraLarge,
                           height: themeManager.selectedTheme.dimens.extraLarge,
                           alignment: .center)
                    .padding(.top, themeManager.selectedTheme.dimens.massive)
                Spacer().frame(height: 30)
                Text(message)
                    .font(.system(size: themeManager.selectedTheme.dimens.large))
                    .padding(.horizontal, themeManager.selectedTheme.dimens.moderatelyLarge)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, themeManager.selectedTheme.dimens.moderatelyLarge)
    }
}

@available(iOS 15.0, *)
struct ProgressInfoComponent_Previews: PreviewProvider {
    static var previews: some View {
        return ProgressInfoComponent(message: "Progress info message")
            .environmentObject(ThemeManager())
            .previewLayout(.sizeThatFits)
    }
}
