import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct PasswordButton: View {
    var secure: Bool? = false
    @Binding var passwordVisible: Bool
    
    var body: some View {
        Button(action: {
            passwordVisible.toggle()
        }) {
            Image(systemName: passwordVisible ? "eye" : "eye.slash")
                .foregroundColor(.gray)
        }
        .padding()
        .opacity(secure == true ? 1 : 0)
    }
}

@available(iOS 15.0, *)
struct SimpleTextField: View {
    var formItem: FormItem
    var hasNextField: Bool
    var isValid: (Bool) -> Void
    var returnValue: (String) -> Void
    @State var passwordVisible: Bool = false
    @State var textFieldValue: String = ""
    @State var error: String = ""
    @State var currentTime: TimeInterval = Date().timeIntervalSince1970
    @State var lastModificationTime: TimeInterval = 0
    @FocusState private var isFocused: Bool
    @ObservedObject var viewModel: KhipuViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            FieldLabel(text: formItem.label, font: themeManager.selectedTheme.fonts.font(style: .regular, size: 14), lineSpacing: Dimens.Spacing.medium, paddingBottom: Dimens.Spacing.extraSmall)
            HStack {
                Group {
                    if formItem.secure != true || passwordVisible {
                        TextField(formItem.placeHolder ?? "", text: $textFieldValue)
                            .focused($isFocused)
                    } else {
                        SecureField(formItem.placeHolder ?? "", text: $textFieldValue)
                            .focused($isFocused)
                    }
                }
                .textFieldStyle(KhipuTextFieldStyle())
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .keyboardType(FieldUtils.getKeyboardType(formItem: formItem))
                .overlay(
                    PasswordButton(secure: formItem.secure, passwordVisible: $passwordVisible),
                    alignment: .trailing
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Dimens.CornerRadius.extraSmall)
                        .stroke(isFocused ? themeManager.selectedTheme.colors.primary : themeManager.selectedTheme.colors.outline, lineWidth: 1)
                )
            }
            .onChange(of: textFieldValue) { newValue in
                onChange(newValue: newValue)
            }
            
            HintLabel(text: formItem.hint)
            
            if shouldDisplayError() {
                ErrorLabel(text: error)
            }
        }
        .padding(.vertical, Dimens.Padding.verySmall)
        .onAppear {
            startTimer()
            if viewModel.uiState.currentForm?.rememberValues ?? false {
                textFieldValue = viewModel.uiState.storedPassword
            }
        }
    }
    
    func onChange(newValue: String) {
        textFieldValue = newValue
        error = ValidationUtils.validateTextField(newValue, formItem, viewModel.uiState.translator)
        isValid(error.isEmpty)
        returnValue(newValue)
        lastModificationTime = Date().timeIntervalSince1970
    }
    
    func shouldDisplayError() -> Bool {
        return !error.isEmpty && (currentTime - lastModificationTime > 1)
    }
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            currentTime = Date().timeIntervalSince1970
        }
    }
}

@available(iOS 15.0, *)
struct KhipuTextField_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = KhipuViewModel()
        let isValid: (Bool) -> Void = { param in }
        let returnValue: (String) -> Void = { param in }
        viewModel.uiState = KhipuUiState()
        viewModel.uiState.translator = KhipuTranslator(translations: [:])
        return VStack {
            SimpleTextField(
                formItem: MockDataGenerator.createTextFormItem(id: "item1", label: "Some text", hint: "Enter some text", placeHolder: "Ej: my text"),
                hasNextField: false,
                isValid: isValid,
                returnValue: returnValue,
                viewModel: viewModel
            )
            SimpleTextField(
                formItem: MockDataGenerator.createTextFormItem(id: "item2", label: "Password", hint: "Enter your password", secure: true),
                hasNextField: false,
                isValid: isValid,
                returnValue: returnValue,
                viewModel: viewModel
            )
        }
        .environmentObject(ThemeManager())
    }
}
