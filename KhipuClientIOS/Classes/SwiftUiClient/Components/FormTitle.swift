import SwiftUI

@available(iOS 14.0, *)
struct FormTitle: View {
    var text: String
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            Text(text)
                .font(.title2)
                .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                .multilineTextAlignment(.center)
        }
    }
}


@available(iOS 14.0, *)
struct FormTitle_Previews: PreviewProvider {
    static var previews: some View {
        FormTitle(text: "Title")
            .environmentObject(ThemeManager())
    }
}
