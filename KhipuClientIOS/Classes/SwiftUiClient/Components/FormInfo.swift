import SwiftUI

@available(iOS 15.0, *)
struct FormInfo: View {
    var text: String
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                Image(systemName: "info.circle")
                    .foregroundColor(themeManager.selectedTheme.colors.info)
                    .frame(width:Dimens.Frame.medium, height:Dimens.Frame.medium)
            }
            .padding(.leading, 0)
            .padding(.trailing,Dimens.Padding.veryMedium)
            .padding(.vertical,Dimens.Padding.extraSmall)
            
            VStack(alignment: .leading, spacing:Dimens.Spacing.verySmall) {
                Text(text)
                    .font(themeManager.selectedTheme.fonts.font(style: .medium, size: 14))
                    .foregroundColor(themeManager.selectedTheme.colors.info)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .padding(.horizontal, 0)
            .padding(.vertical,Dimens.Padding.extraSmall)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
            
        }
        .padding(.horizontal,Dimens.Padding.extraMedium)
        .padding(.vertical,Dimens.Padding.moderatelySmall)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .cornerRadius(Dimens.CornerRadius.verySmall)
        .overlay(
            RoundedRectangle(cornerRadius:Dimens.CornerRadius.verySmall)
                .inset(by: 0.5)
                .stroke(themeManager.selectedTheme.colors.info, lineWidth: 1)
        )
        
    }
}

@available(iOS 15.0, *)
struct FormInfo_Previews: PreviewProvider {
    static var previews: some View {
        FormInfo(text: "Info text")
            .environmentObject(ThemeManager())
            .padding()
    }
}
