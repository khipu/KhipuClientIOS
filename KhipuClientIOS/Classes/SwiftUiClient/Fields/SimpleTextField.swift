import SwiftUI
import KhenshinProtocol



@available(iOS 15.0, *)
struct PasswordButton: View {
    var secure: Bool? = false
    @Binding var  passwordVisible: Bool
    
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
    @ObservedObject var viewModel: KhipuViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        
        VStack(alignment: .leading, spacing:0) {
            FieldLabel(text: formItem.label)
            HStack {
                Group {
                    if formItem.secure != true || passwordVisible {
                        TextField(formItem.placeHolder ?? "", text: $textFieldValue)
                    } else {
                        SecureField(formItem.placeHolder ?? "", text: $textFieldValue)
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
            }
            .onChange(of: textFieldValue) { newValue in
                onChange(newValue: newValue)
            }
            
            HintLabel(text: formItem.hint)
            
            if shouldDisplayError() {
                ErrorLabel(text: error)
            }
        }
        .padding(.vertical, themeManager.selectedTheme.dimens.verySmall)
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
        
        let formItem1 = try! FormItem(
                 """
                     {
                       "id": "Some text",
                       "label": "item1",
                       "type": "\(FormItemTypes.text.rawValue)",
                       "hint": "Enter some text",
                       "placeHolder": "Ej: my text"
                     }
                 """
        )
        let formItem2 = try! FormItem(
                 """
                     {
                       "id": "item2",
                       "label": "Password",
                       "secure": true,
                       "type": "\(FormItemTypes.text.rawValue)",
                       "hint": "Enter your password"
                     }
                 """
        )
        return VStack {
            SimpleTextField(
                formItem: formItem1,
                hasNextField: false,
                isValid:  isValid,
                returnValue: returnValue,
                viewModel: viewModel
            )
            SimpleTextField(
                formItem: formItem2,
                hasNextField: false,
                isValid:  isValid,
                returnValue: returnValue,
                viewModel: viewModel
            )
        }
        .environmentObject(ThemeManager())
    }
}
