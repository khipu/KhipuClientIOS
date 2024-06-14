import SwiftUI

@available(iOS 13.0, *)
struct CircularProgressView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var drawingStroke = false
    
    let animation = Animation
        .easeOut(duration: 2)
        .repeatForever(autoreverses: false)
        .delay(0.5)
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    themeManager.selectedTheme.colors.surface,
                    lineWidth: themeManager.selectedTheme.dimens.small
                )
            Circle()
                .trim(from: 0, to: drawingStroke ? 1 : 0)
                .stroke(
                    themeManager.selectedTheme.colors.primary,
                    style: StrokeStyle(
                        lineWidth: themeManager.selectedTheme.dimens.small,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(animation, value: drawingStroke)
            
        }
        .onAppear {
            drawingStroke.toggle()
        }
    }
}

@available(iOS 13.0, *)
struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView()
            .environmentObject(ThemeManager())
            .padding()
    }
}
