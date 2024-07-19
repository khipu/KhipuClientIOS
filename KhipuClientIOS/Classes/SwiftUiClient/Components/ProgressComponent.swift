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

/*
@available(iOS 15.0, *)
struct ProgressComponent_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = KhipuViewModel()
        viewModel.setCurrentProgress(currentProgress: 0.5)
        let viewModel2 = KhipuViewModel()
        viewModel2.setCurrentProgress(currentProgress: 1)
        return VStack{
            Text("Progress 0%")
            ProgressComponent(viewModel: KhipuViewModel())
                .environmentObject(ThemeManager())
                .previewLayout(.sizeThatFits)
            Text("Progress 50%")
            ProgressComponent(viewModel: viewModel)
                .environmentObject(ThemeManager())
                .previewLayout(.sizeThatFits)
            Text("Progress 100%")
            ProgressComponent(viewModel: viewModel2)
                .environmentObject(ThemeManager())
                .previewLayout(.sizeThatFits)
        }
    }
}*/
