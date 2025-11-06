import SwiftUI

@available(iOS 13.0, *)
struct CircularProgressView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    themeManager.selectedTheme.colors.outlineVariant,
                    lineWidth: 4
                )
            Circle()
                .trim(from: 0, to: 0.25)
                .stroke(
                    themeManager.selectedTheme.colors.primary,
                    style: StrokeStyle(
                        lineWidth: 4,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(rotation))
                .animation(
                    Animation.linear(duration: 1)
                        .repeatForever(autoreverses: false),
                    value: rotation
                )
        }
        .onAppear {
            rotation = 360
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
