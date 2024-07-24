import SwiftUI

@available(iOS 15.0, *)
struct ProgressComponent: View {
    var currentProgress: Float
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        ProgressView(value: Double(currentProgress))
            .progressViewStyle(.linear)
            .tint(themeManager.selectedTheme.colors.primary)
            .background(themeManager.selectedTheme.colors.surface)
            .accessibility(identifier: "linearProgressIndicator")
            .padding(.all, 0)
    }
}


@available(iOS 15.0, *)
struct ProgressComponent_Previews: PreviewProvider {
    static var previews: some View {
        return VStack{
            Text("Progress 0%")
            ProgressComponent(currentProgress: 0.0)
                .environmentObject(ThemeManager())
                .previewLayout(.sizeThatFits)
            Text("Progress 50%")
            ProgressComponent(currentProgress: 0.5)
                .environmentObject(ThemeManager())
                .previewLayout(.sizeThatFits)
            Text("Progress 100%")
            ProgressComponent(currentProgress: 1.0)
                .environmentObject(ThemeManager())
                .previewLayout(.sizeThatFits)
        }
    }
}
