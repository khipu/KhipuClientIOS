import SwiftUI

@available(iOS 13.0, *)
struct FormTitle: View {
    var text: String
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            Text(text)
                .font(.title)
                .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

@available(iOS 13.0, *)
struct FormTitle_Previews: PreviewProvider {
    static var previews: some View {
        FormTitle(text: "Título")
    }
}
