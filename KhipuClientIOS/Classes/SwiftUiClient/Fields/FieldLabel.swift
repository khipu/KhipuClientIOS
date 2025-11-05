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
    var materialStyle: Bool = false
    var isFocused: Bool = false

    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        if !(text?.isEmpty ?? true) {
            if materialStyle {
                Text(text ?? "")
                    .font(.custom("Roboto", size: 12).weight(.regular))
                    .tracking(0.15)
                    .lineSpacing(0)
                    .foregroundColor(isFocused ? (Color(hexString: "#8347AD") ?? themeManager.selectedTheme.colors.primary) : (foregroundColor ?? Color.black.opacity(0.6)))
                    .padding(.horizontal, 4)
                    .background(Color.white)
                    .accessibilityIdentifier("labelText")
            } else {
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
}

@available(iOS 15.0, *)
struct FieldLabel_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            FieldLabel(text: "Field label", font: .body)
                .environmentObject(ThemeManager())

            FieldLabel(
                text: "Email",
                font: .body,
                materialStyle: true,
                isFocused: false
            )
            .environmentObject(ThemeManager())

            FieldLabel(
                text: "Email",
                font: .body,
                materialStyle: true,
                isFocused: true
            )
            .environmentObject(ThemeManager())
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
