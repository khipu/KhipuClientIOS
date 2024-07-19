import SwiftUI
@available(iOS 15.0, *)
struct FailureMessageHeaderComponent: View {
    var icon: String? = nil
    var title: String? = nil
    var subtitle: String? = nil
    var bodyText: String? = nil
    @EnvironmentObject private var themeManager: ThemeManager
    
    
    var body: some View {
        VStack(spacing: 16) {
            if let icon = icon {
                VStack(alignment: .center, spacing:Dimens.Spacing.medium) {
                    Image(systemName: icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Dimens.Image.slightlyLarger, height: Dimens.Image.slightlyLarger)
                        .foregroundColor(themeManager.selectedTheme.colors.tertiary)
                    
                }
                .padding(0)
                .frame(maxWidth: .infinity, alignment: .top)
                .cornerRadius(8)
            }
            
            if let title = title {
                VStack(alignment: .center, spacing:Dimens.Spacing.medium) {
                    Text(title)
                        .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 24))
                        .multilineTextAlignment(.center)
                        .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                    
                }
                .padding(0)
                .frame(maxWidth: .infinity, alignment: .top)
                .cornerRadius(8)
            }
            
            if let subtitle = subtitle {
                HStack(alignment: .center, spacing:Dimens.Spacing.medium) {
                    Text(subtitle)
                        .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 16))
                        .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal,Dimens.Padding.moderatelyLarge)
                .padding(.vertical, 0)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            
            if let bodyText = bodyText {
                FormWarning(text: bodyText).padding(.bottom, Dimens.Spacing.large) 
            }
        }
        
    }
}
