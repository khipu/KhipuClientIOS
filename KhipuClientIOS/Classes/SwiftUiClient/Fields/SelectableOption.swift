import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct SelectableOption<Content: View>: View  {
    var selected: Bool
    let content: () -> Content
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        
        HStack(alignment: .center, spacing: themeManager.selectedTheme.dimens.extraMedium) {
            content()
        }
        .padding(.horizontal, themeManager.selectedTheme.dimens.large)
        .padding(.vertical, themeManager.selectedTheme.dimens.medium)
        .frame(maxWidth: .infinity, minHeight: themeManager.selectedTheme.dimens.substantiallyLarge, maxHeight: themeManager.selectedTheme.dimens.substantiallyLarge, alignment: .leading)
        .background(themeManager.selectedTheme.colors.background)
        .cornerRadius(themeManager.selectedTheme.dimens.moderatelySmall)
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
