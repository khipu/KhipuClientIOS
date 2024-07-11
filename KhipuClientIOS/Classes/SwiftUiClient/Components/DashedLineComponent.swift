import SwiftUI

@available(iOS 13.0, *)
struct DashedLine: View {
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        Line()
            .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
            .foregroundColor(themeManager.selectedTheme.colors.onSurfaceVariant)
            .frame(height: 1)
    }
}

@available(iOS 13.0, *)
struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

@available(iOS 13.0, *)
struct DashedLine_Previews: PreviewProvider {
    static var previews: some View {
        DashedLine().environmentObject(ThemeManager())

    }
}
