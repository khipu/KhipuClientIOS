import SwiftUI

@available(iOS 15.0, *)
struct FormWarning: View {
    var text: String
    @ObservedObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
                .frame(width: Dimens.medium)
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: Dimens.large, height: Dimens.large)
                .foregroundColor(themeManager.selectedTheme.tertiary)
            Text(text)
                .padding(.all, Dimens.medium)
                .foregroundColor(themeManager.selectedTheme.onTertiary)
                .font(.system(size: 16, weight: .regular))
            Spacer()
        }
        .padding(.all, Dimens.verySmall)
        .background(themeManager.selectedTheme.surface)
        .overlay(
            RoundedRectangle(cornerRadius: Dimens.extraSmall)
                .stroke(themeManager.selectedTheme.tertiary, lineWidth: 1)
                )
        
    }
}
