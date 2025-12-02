import Foundation
import SwiftUI

@available(iOS 15.0.0, *)
struct TopBarComponent: View {
    var onClose: (() -> Void)? = nil
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        HStack(alignment: .center, spacing: Dimens.slightlyLarger) {
            if let logoImage = KhipuClientBundleHelper.image(named: "logo-khipu-color") {
                Image(uiImage: logoImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Dimens.Image.khipuLogoWidth, height: Dimens.Image.khipuLogoHeight)
            }

            Spacer()

            if let onClose = onClose {
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)
                        .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                }
            }
        }
        .padding(.horizontal, Dimens.large)
        .padding(.vertical, Dimens.medium)
        .background(themeManager.selectedTheme.colors.surface)
    }
}

@available(iOS 15.0.0, *)
struct TopBarComponent_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return VStack(spacing: 20) {
            Text("Without Close Button:")
            TopBarComponent()
                .environmentObject(themeManager)

            Text("With Close Button:")
            TopBarComponent(onClose: { print("Close tapped") })
                .environmentObject(themeManager)
        }
        .padding()
    }
}
