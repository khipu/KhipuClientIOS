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
                    .frame(width: Dimens.Frame.extraLarge,
                           height:Dimens.Frame.extraLarge,
                           alignment: .center)
                    .padding(.top,Dimens.Padding.massive)
                Spacer().frame(height: 30)
                Text(message)
                    .font(themeManager.selectedTheme.fonts.font(style: .medium, size: 14))
                    .padding(.horizontal,Dimens.Padding.moderatelyLarge)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal,Dimens.Padding.moderatelyLarge)
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
