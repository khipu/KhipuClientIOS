import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct SelectableOption<Content: View>: View  {
    var selected: Bool
    let content: () -> Content
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        
        HStack(alignment: .center, spacing:Dimens.Spacing.extraMedium) {
            content()
        }
        .padding(.horizontal,Dimens.Padding.large)
        .padding(.vertical,Dimens.Padding.medium)
        .frame(maxWidth: .infinity, minHeight:Dimens.Frame.substantiallyLarge, maxHeight: Dimens.Frame.substantiallyLarge, alignment: .leading)
        .background(themeManager.selectedTheme.colors.background)
        .cornerRadius(Dimens.CornerRadius.moderatelySmall)
        .overlay(
            RoundedRectangle(cornerRadius:Dimens.CornerRadius.extraSmall)
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
