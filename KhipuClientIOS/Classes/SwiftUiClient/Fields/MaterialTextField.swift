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
            HStack(spacing: Dimens.Spacing.extraSmall) {
                if isSecure {
                    SecureField(placeholder ?? "", text: $text)
                        .font(themeManager.selectedTheme.fonts.font(style: .regular, size: 16))
                        .foregroundColor(themeManager.selectedTheme.colors.onBackground)
                        .focused($isFocused)
                } else {
                    TextField(placeholder ?? "", text: $text)
                        .font(themeManager.selectedTheme.fonts.font(style: .regular, size: 16))
                        .foregroundColor(themeManager.selectedTheme.colors.onBackground)
                        .focused($isFocused)
                }

                if let icon = trailingIcon {
                    Button(action: {
                        onTrailingIconTap?()
                    }) {
                        Image(systemName: icon)
                            .foregroundColor(themeManager.selectedTheme.colors.onSurfaceVariant)
                            .frame(width: Dimens.Frame.icon, height: Dimens.Frame.icon)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.vertical, Dimens.extraMedium)
            .padding(.horizontal, Dimens.veryMedium)
            .background(themeManager.selectedTheme.colors.surface)
            .keyboardType(keyboardType)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .overlay(
                RoundedRectangle(cornerRadius: Dimens.CornerRadius.verySmall)
                    .stroke(
                        isFocused ?
                            themeManager.selectedTheme.colors.primary :
                            themeManager.selectedTheme.colors.outline,
                        lineWidth: isFocused ? 2 : 1
                    )
            )

            if !label.isEmpty {
                VStack {
                    HStack {
                        Text(label)
                            .font(themeManager.selectedTheme.fonts.font(style: .regular, size: 12))
                            .tracking(0.15)
                            .foregroundColor(
                                isFocused ?
                                    themeManager.selectedTheme.colors.primary :
                                    themeManager.selectedTheme.colors.onSurfaceVariant
                            )
                            .padding(.horizontal, Dimens.verySmall)
                            .background(themeManager.selectedTheme.colors.surface)
                            .accessibilityIdentifier("labelText")
                        Spacer()
                    }
                    .padding(.leading, Dimens.extraSmall)
                    .offset(y: -1)
                    Spacer()
                }
            }
        }
        .frame(height: Dimens.Frame.materialTextField)
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
