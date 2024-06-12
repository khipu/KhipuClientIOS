import SwiftUI

@available(iOS 15.0, *)
struct FormWarning: View {
    var text: String
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
                .frame(width: themeManager.selectedTheme.dimens.small)
            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .scaledToFit()
                .frame(width: themeManager.selectedTheme.dimens.large, height: themeManager.selectedTheme.dimens.large)
                .foregroundColor(themeManager.selectedTheme.colors.tertiary)
            Text(text)
                .padding(.all, themeManager.selectedTheme.dimens.medium)
                .foregroundColor(themeManager.selectedTheme.colors.onTertiary)
                .font(.system(size: 16, weight: .regular))
            Spacer()
        }
        .padding(.all, themeManager.selectedTheme.dimens.verySmall)
        .background(themeManager.selectedTheme.colors.surface)
        .overlay(
            RoundedRectangle(cornerRadius: themeManager.selectedTheme.dimens.extraSmall)
                .stroke(themeManager.selectedTheme.colors.tertiary, lineWidth: 0.3)
                )
        
    }
}

@available(iOS 15.0, *)
struct FormWarning_Previews: PreviewProvider{
    static var previews: some View {
        FormWarning(text: "Warning text")
            .environmentObject(ThemeManager())
            .padding()
    }
}
