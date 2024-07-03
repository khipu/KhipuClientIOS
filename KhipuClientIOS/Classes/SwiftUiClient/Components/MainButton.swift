import SwiftUI

@available(iOS 13.0, *)
struct MainButton: View {
    let text: String
    let enabled: Bool
    let onClick: () -> Void
    let foregroundColor: Color
    let backgroundColor: Color
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var submitted = false

    var body: some View {
        HStack(alignment: .center, spacing: themeManager.selectedTheme.dimens.extraSmall) {

            Button(action: {
                submitted = true
                onClick()
            }) {
                Text(text)
                    .foregroundColor(enabled && !submitted ? foregroundColor :themeManager.selectedTheme.colors.buttonForeground)
                    .padding(.horizontal, themeManager.selectedTheme.dimens.moderatelyLarge)
                    .padding(.vertical, themeManager.selectedTheme.dimens.moderatelySmall)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(enabled && !submitted ? backgroundColor : themeManager.selectedTheme.colors.buttonBackground)
                    .font(themeManager.selectedTheme.fonts.font(style: .medium, size: 18))
            }
            .disabled(!enabled && !submitted)

        }
        .padding(.horizontal, themeManager.selectedTheme.dimens.moderatelyLarge)
        .padding(.vertical, themeManager.selectedTheme.dimens.moderatelySmall)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(enabled && !submitted ? backgroundColor :themeManager.selectedTheme.colors.buttonBackground)
        .cornerRadius(themeManager.selectedTheme.dimens.moderatelySmall)
    }
}

@available(iOS 13.0, *)
struct MainButton_Previews: PreviewProvider {
    static var previews: some View {
        let onClick: () -> Void = {}
        return VStack {
            MainButton(
                text: "Enabled buton",
                enabled: true,
                onClick: onClick,
                foregroundColor: Color(hexString: "#FFFFFF")!,
                backgroundColor: Color(hexString: "#8347AC")!
            )
            MainButton(
                text: "Disabled buton",
                enabled: false,
                onClick: onClick,
                foregroundColor: Color(hexString: "#FFFFFF")!,
                backgroundColor: Color(hexString: "#8347AC")!
            )
        }
        .environmentObject(ThemeManager())
        .padding()
    }
}
