import SwiftUI

@available(iOS 15.0, *)
struct MaterialTextField: View {
    var label: String
    var placeholder: String?
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var trailingIcon: String? = nil
    var onTrailingIconTap: (() -> Void)? = nil
    @FocusState.Binding var isFocused: Bool
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        ZStack(alignment: .leading) {
            HStack(spacing: 8) {
                if isSecure {
                    SecureField(placeholder ?? "", text: $text)
                        .font(.custom("Roboto", size: 16).weight(.regular))
                        .foregroundColor(Color.black.opacity(0.87))
                        .focused($isFocused)
                } else {
                    TextField(placeholder ?? "", text: $text)
                        .font(.custom("Roboto", size: 16).weight(.regular))
                        .foregroundColor(Color.black.opacity(0.87))
                        .focused($isFocused)
                }

                if let icon = trailingIcon {
                    Button(action: {
                        onTrailingIconTap?()
                    }) {
                        Image(systemName: icon)
                            .foregroundColor(Color.black.opacity(0.54))
                            .frame(width: 24, height: 24)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
            .background(Color.white)
            .keyboardType(keyboardType)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(
                        isFocused ?
                            (Color(hexString: "#7E57C2") ?? themeManager.selectedTheme.colors.primary) :
                            (Color.black.opacity(0.23)),
                        lineWidth: isFocused ? 2 : 1
                    )
            )

            if !label.isEmpty {
                VStack {
                    HStack {
                        Text(label)
                            .font(.custom("Roboto", size: 12).weight(.regular))
                            .tracking(0.15)
                            .foregroundColor(
                                isFocused ?
                                    (Color(hexString: "#7E57C2") ?? themeManager.selectedTheme.colors.primary) :
                                    Color.black.opacity(0.6)
                            )
                            .padding(.horizontal, 4)
                            .background(Color.white)
                        Spacer()
                    }
                    .padding(.leading, 8)
                    .offset(y: -1)
                    Spacer()
                }
            }
        }
        .frame(height: 56)
    }
}

@available(iOS 15.0, *)
struct MaterialTextField_Previews: PreviewProvider {
    @State static var email = ""
    @State static var password = ""
    @FocusState static var isEmailFocused: Bool
    @FocusState static var isPasswordFocused: Bool

    static var previews: some View {
        VStack(spacing: 20) {
            MaterialTextField(
                label: "Email",
                placeholder: "ejemplo@correo.com",
                text: $email,
                isFocused: $isEmailFocused
            )
            .environmentObject(ThemeManager())

            MaterialTextField(
                label: "Clave",
                placeholder: "Clave banca en línea",
                text: $password,
                isSecure: true,
                trailingIcon: "eye.slash",
                onTrailingIconTap: {
                    print("Toggle password visibility")
                },
                isFocused: $isPasswordFocused
            )
            .environmentObject(ThemeManager())

            MaterialTextField(
                label: "RUT",
                placeholder: "EJ: 12.345.678-9",
                text: $email,
                keyboardType: .numberPad,
                trailingIcon: "person.fill",
                isFocused: $isEmailFocused
            )
            .environmentObject(ThemeManager())
        }
        .padding()
    }
}
