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
        Button(action: {
            submitted = true
            onClick()
        }) {
            Text(text)
                .foregroundColor(enabled && !submitted ? foregroundColor : .secondary.opacity(0.3))
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(enabled && !submitted ? backgroundColor : .gray.opacity(0.5))
                .cornerRadius(themeManager.selectedTheme.dimens.extraSmall)
        }
        .disabled(!enabled && !submitted)
    }
}
