import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct SelectableOption<Content: View>: View  {
    var selected: Bool
    let content: () -> Content
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 16) {
            content()
        }
        .padding(.horizontal, themeManager.selectedTheme.dimens.large)
        .padding(.vertical, themeManager.selectedTheme.dimens.medium)
        .frame(maxWidth: .infinity, minHeight: 65, maxHeight: 65, alignment: .leading)
        .background(themeManager.selectedTheme.colors.background)
        .cornerRadius(6)
        .overlay(
            RoundedRectangle(cornerRadius: themeManager.selectedTheme.dimens.extraSmall)
                .stroke(themeManager.selectedTheme.colors.onSurface, lineWidth: 0.5)
        )
    }
}


@available(iOS 15.0, *)
struct ListOption_Previews: PreviewProvider {
    static var previews: some View {
        
        return VStack {
            SelectableOption(selected: true) {
                Text("hello")
            }
            SelectableOption(selected: false) {
                Text("goodbye")
            }
            
        }
        .padding()
        .environmentObject(ThemeManager())
    }
}
