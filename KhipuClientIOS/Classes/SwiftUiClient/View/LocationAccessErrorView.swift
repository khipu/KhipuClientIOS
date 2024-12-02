import SwiftUI

@available(iOS 15.0.0, *)
struct LocationAccessErrorView: View {
    let translator: KhipuTranslator
    let operationId: String
    let bank: String
    let continueButton: () -> Void
    let declineButton: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "gearshape.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Dimens.Image.huge, height: Dimens.Image.huge)
                .foregroundColor(Color(hexString: "#ED6C02"))
                .padding(.bottom, 24)
            
            Text(translator.t("geolocation.blocked.title"))
                .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 24))
                .multilineTextAlignment(.center)
            
            Text(translator.t("geolocation.blocked.description").replacingOccurrences(of: "{{bank}}", with: bank))
                .font(themeManager.selectedTheme.fonts.font(style: .regular, size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(themeManager.selectedTheme.colors.onSurfaceVariant)
                .padding(.horizontal, 16)
            
            Button(action: continueButton) {
                Text(translator.t("geolocation.blocked.button.continue"))
                    .font(themeManager.selectedTheme.fonts.font(style: .medium, size: 16))
                    .foregroundColor(themeManager.selectedTheme.colors.onPrimary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(themeManager.selectedTheme.colors.primary)
                    .cornerRadius(8)
            }
            .padding(.top, 24)
            
            Button(action: declineButton) {
                Text(translator.t("geolocation.blocked.button.decline"))
                    .font(themeManager.selectedTheme.fonts.font(style: .medium, size: 16))
                    .foregroundColor(themeManager.selectedTheme.colors.error)
                    .padding()
            }
        }
        .padding(24)
        .background(themeManager.selectedTheme.colors.surface)
    }
}

@available(iOS 15.0, *)
struct LocationAccessErrorView_Previews: PreviewProvider {
    static var previews: some View {
        LocationAccessErrorView(
            translator: MockDataGenerator.createTranslator(),
            operationId: "test-operation",
            bank: "test-bank",
            continueButton: {},
            declineButton: {}
        )
        .environmentObject(ThemeManager())
    }
}