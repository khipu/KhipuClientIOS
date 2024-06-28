import SwiftUI

@available(iOS 13.0, *)
struct ErrorLabel: View {
    var text: String
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            Spacer()
            Text(text)
                .font(themeManager.selectedTheme.fonts.regular12)
                .foregroundColor(themeManager.selectedTheme.colors.error)
        }
        .padding(.top, themeManager.selectedTheme.dimens.verySmall)
    }
}

@available(iOS 13.0, *)
struct ErrorLabel_Previews: PreviewProvider {
    static var previews: some View {
        
        return ErrorLabel(text: "This is an error message")
            .environmentObject(ThemeManager())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
