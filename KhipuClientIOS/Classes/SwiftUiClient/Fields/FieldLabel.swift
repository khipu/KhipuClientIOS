import SwiftUI

@available(iOS 15.0, *)
struct FieldLabel: View {
    var text: String?
    var font: Font
    var lineSpacing: CGFloat?
    var paddingBottom: CGFloat?
    var paddingTop: CGFloat?
    var paddingHorizontal: CGFloat?
    var paddingVertical: CGFloat?
    var foregroundColor: Color?

    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        if !(text?.isEmpty ?? true) {
            VStack {
                Text(text ?? "")
                    .font(font)
                    .accessibilityIdentifier("labelText")
                    .lineSpacing(lineSpacing ?? 0)
                    .padding(.bottom, paddingBottom ?? 0)
                    .padding(.top, paddingTop ?? 0)
                    .padding(.horizontal, paddingHorizontal ?? 0)
                    .padding(.vertical, paddingVertical ?? 0)
                    .foregroundColor(foregroundColor)
            }
        }
    }
}

@available(iOS 15.0, *)
struct FieldLabel_Previews: PreviewProvider {
    static var previews: some View {
        return FieldLabel(text: "Field label", font: .body)
            .environmentObject(ThemeManager())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
