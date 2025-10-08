import SwiftUI

@available(iOS 15.0, *)
struct FormPill: View {
    var text: String
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack(alignment: .center, spacing:Dimens.Spacing.moderatelySmall) {
            Text(text)
                .font(themeManager.selectedTheme.fonts.font(style: .medium, size: 14))
                .foregroundColor(themeManager.selectedTheme.colors.onBackground)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)

        }
        .padding(.horizontal,Dimens.Padding.veryMedium)
        .padding(.vertical, Dimens.Padding.moderatelySmall)
        .frame(minHeight: Dimens.Frame.quiteLarge)
        .cornerRadius(Dimens.CornerRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius:Dimens.CornerRadius.large)
                .stroke(themeManager.selectedTheme.colors.onBackground, lineWidth:0.5)
            
        )
    }
}

@available(iOS 15.0, *)
struct FormPill_Previews: PreviewProvider {
    static var previews: some View {
        FormPill(text: "Bank name")
            .environmentObject(ThemeManager())
    }
}
