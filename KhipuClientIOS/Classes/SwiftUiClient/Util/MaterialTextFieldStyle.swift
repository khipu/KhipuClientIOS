import SwiftUI

@available(iOS 15.0, *)
struct MaterialTextFieldStyle: TextFieldStyle {
    var label: String
    var isFocused: Bool
    @EnvironmentObject private var themeManager: ThemeManager

    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack(alignment: .leading) {
            configuration
                .padding(.vertical, 16)
                .padding(.horizontal, 12)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(
                            isFocused ?
                                (Color(hexString: "#8347AD") ?? themeManager.selectedTheme.colors.primary) :
                                (Color(hexString: "rgba(0,0,0,0.23)") ?? Color.black.opacity(0.23)),
                            lineWidth: isFocused ? 2 : 1
                        )
                )

            if !label.isEmpty {
                VStack {
                    HStack {
                        FieldLabel(
                            text: label,
                            font: .body,
                            materialStyle: true,
                            isFocused: isFocused
                        )
                        Spacer()
                    }
                    .padding(.leading, 12)
                    .offset(y: -1)
                    Spacer()
                }
            }
        }
    }
}

@available(iOS 15.0, *)
struct MaterialTextFieldStyle_Previews: PreviewProvider {
    @State static var email = ""
    @State static var isFocused = false

    static var previews: some View {
        VStack(spacing: 20) {
            TextField("", text: $email)
                .textFieldStyle(MaterialTextFieldStyle(label: "Email", isFocused: false))
                .environmentObject(ThemeManager())

            TextField("", text: $email)
                .textFieldStyle(MaterialTextFieldStyle(label: "Email", isFocused: true))
                .environmentObject(ThemeManager())
        }
        .padding()
    }
}
