import SwiftUI

@available(iOS 15.0, *)
struct FormInfo: View {
    var text: String
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                Image(systemName: "info.circle")
                    .foregroundColor(themeManager.selectedTheme.colors.secondary)
                    .frame(width: 22, height: 22)
            }
            .padding(.leading, 0)
            .padding(.trailing, themeManager.selectedTheme.dimens.veryMedium)
            .padding(.vertical, themeManager.selectedTheme.dimens.extraSmall)
            
            VStack(alignment: .leading, spacing: themeManager.selectedTheme.dimens.verySmall) {
                Text(text)
                    .font(themeManager.selectedTheme.fonts.font(style: .medium, size: 14))
                    .foregroundColor(themeManager.selectedTheme.colors.secondary)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .padding(.horizontal, 0)
            .padding(.vertical, themeManager.selectedTheme.dimens.extraSmall)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
            
        }
        .padding(.horizontal, themeManager.selectedTheme.dimens.extraMedium)
        .padding(.vertical, themeManager.selectedTheme.dimens.moderatelySmall)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .cornerRadius(themeManager.selectedTheme.dimens.verySmall)
        .overlay(
            RoundedRectangle(cornerRadius: themeManager.selectedTheme.dimens.verySmall)
                .inset(by: 0.5)
                .stroke(themeManager.selectedTheme.colors.secondary, lineWidth: 1)
        )
        
    }
}

@available(iOS 15.0, *)
struct FormInfo_Previews: PreviewProvider {
    static var previews: some View {
        FormInfo(text: "Info text")
            .environmentObject(ThemeManager())
            .padding()
    }
}
