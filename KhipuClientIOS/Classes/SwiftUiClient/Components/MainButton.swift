import SwiftUI

@available(iOS 13.0, *)
struct MainButton: View {
    let text: String
    let enabled: Bool
    let onClick: () -> Void
    let foregroundColor: Color
    let backgroundColor: Color
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var submitted = false

    var body: some View {
        Button(action: {
            submitted = true
            onClick()
        }) {
            Text(text.uppercased())
                .font(.custom("Roboto", size: 15).weight(.medium))
                .foregroundColor(enabled && !submitted ? foregroundColor : Color.black.opacity(0.38))
                .tracking(0.46)
                .lineSpacing(11)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
        }
        .disabled(!enabled && !submitted)
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(enabled && !submitted ? backgroundColor : Color.black.opacity(0.12))
        .cornerRadius(4)
    }
}

@available(iOS 13.0, *)
struct MainButton_Previews: PreviewProvider {
    static var previews: some View {
        let onClick: () -> Void = {}
        return VStack {
            MainButton(
                text: "Enabled buton",
                enabled: true,
                onClick: onClick,
                foregroundColor: Color(hexString: "#FFFFFF")!,
                backgroundColor: Color(hexString: "#8347AC")!
            )
            MainButton(
                text: "Disabled buton",
                enabled: false,
                onClick: onClick,
                foregroundColor: Color(hexString: "#FFFFFF")!,
                backgroundColor: Color(hexString: "#8347AC")!
            )
        }
        .environmentObject(ThemeManager())
        .padding()
    }
}
