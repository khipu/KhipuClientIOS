import SwiftUI

@available(iOS 15.0, *)
struct HintLabel: View {
    var text: String?
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            Spacer()
            Text(text ?? "")
                .font(.caption)
                .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                .accessibilityIdentifier("hintText")
        }
        .padding(.top, 5)
    }
}

@available(iOS 15.0, *)
struct HintLabel_Previews: PreviewProvider {
    static var previews: some View {
        return HintLabel(text: "This is a hint label")
            .environmentObject(ThemeManager())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
