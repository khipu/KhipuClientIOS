import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct KhipuListOption<Content: View>: View  {
    var selected: Bool
    let content: () -> Content
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: Dimensions.small) {
          content()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
                RoundedRectangle(cornerRadius: themeManager.selectedTheme.dimens.extraSmall)
                    .foregroundColor( selected ? themeManager.selectedTheme.colors.onSecondaryContainer: Color(UIColor.systemBackground))
            
        )
        .overlay(
            RoundedRectangle(cornerRadius: themeManager.selectedTheme.dimens.extraSmall)
                .stroke(themeManager.selectedTheme.colors.onBackground, lineWidth: 0.5)
        )
    }
}


@available(iOS 15.0, *)
struct KhipuListOption_Previews: PreviewProvider {
    static var previews: some View {
        
        return VStack {
            KhipuListOption(selected: true) {
                Text("hello")
            }
            KhipuListOption(selected: false) {
                Text("goodbye")
            }

        }
        .padding()
        .environmentObject(ThemeManager())
    }
}
