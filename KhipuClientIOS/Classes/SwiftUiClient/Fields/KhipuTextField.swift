import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct KhipuTextField: View {
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
                if formItem.secure == true {
                    if passwordVisible {
                        TextField(formItem.placeHolder ?? "", text: $textFieldValue)
                            .textFieldStyle(.roundedBorder)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .keyboardType(FieldUtils.getKeyboardType(formItem: formItem))
                            .overlay(
                                Button(action: {
                                    passwordVisible.toggle()
                                }) {
                                    Image(systemName: passwordVisible ? "eye" : "eye.slash")
                                        .foregroundColor(.gray)
                                }
                                    .padding(),
                                alignment: .trailing
                            )
                    } else {
                        SecureField(formItem.placeHolder ?? "", text: $textFieldValue)
                            .textFieldStyle(.roundedBorder)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .keyboardType(FieldUtils.getKeyboardType(formItem: formItem))
                            .overlay(
                                Button(action: {
                                    passwordVisible.toggle()
                                }) {
                                    Image(systemName: passwordVisible ? "eye" : "eye.slash")
                                        .foregroundColor(.gray)
                                }
                                    .padding(),
                                alignment: .trailing
                            )
                    }
                } else {
                    TextField(formItem.placeHolder ?? "", text: $textFieldValue)
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .multilineTextAlignment(.leading)
                        .keyboardType(FieldUtils.getKeyboardType(formItem: formItem))
                }
            }
            .onChange(of: textFieldValue) { newValue in
                onChange(newValue: newValue)
            }
            
            if !(formItem.hint?.isEmpty ?? true) {
                HintLabel(text: formItem.hint)
            }
            if shouldDisplayError() {
                ErrorLabel(text: error)
            }
        }
        .padding(.vertical, themeManager.selectedTheme.dimens.verySmall)
        .onAppear {
            startTimer()
            if(viewModel.uiState.currentForm?.rememberValues ?? false) {
                textFieldValue = viewModel.uiState.storedPassword
            }
        }
    }
    
    func onChange(newValue: String) {
        textFieldValue = newValue
        error = validateTextField(value: newValue, formItem: formItem)
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
    
    func validateTextField(value: String, formItem: FormItem) -> String {
        if value.isEmpty {
            return viewModel.uiState.translator.t("form.validation.error.default.empty")
        }
        if !ValidationUtils.validMinLength(value, minLength: formItem.minLength) {
            let minLengthString = formItem.minLength.map { String(Int($0)) } ?? "nil"
            return viewModel.uiState.translator.t("form.validation.error.default.minLength.not.met").replacingOccurrences(of: "{{min}}", with: minLengthString)
        }
        if !ValidationUtils.validMaxLength(value, maxLength: formItem.maxLength) {
            let maxLengthString = formItem.maxLength.map { String(Int($0)) } ?? "nil"
            return viewModel.uiState.translator.t("form.validation.error.default.maxLength.exceeded").replacingOccurrences(of: "{{max}}", with: maxLengthString)
        }
        if formItem.email == true && !ValidationUtils.isValidEmail(value) {
            return viewModel.uiState.translator.t("form.validation.error.default.email.invalid")
        }
        
        if (!FieldUtils.isEmpty(formItem.pattern) && !FieldUtils.matches(value, regex: formItem.pattern!)){
            return viewModel.uiState.translator.t("form.validation.error.default.pattern.invalid")
        }
        
        if formItem.number == true {
            do {
                guard let number = Double(value) else {
                    throw NumberFormatError.invalidNumber
                }
                
                if !ValidationUtils.validMinValue(number, minValue: formItem.minValue) {
                    let minValue = formItem.minValue.map { String(Int($0)) } ?? "nil"
                    return viewModel.uiState.translator.t("form.validation.error.default.minValue.not.met").replacingOccurrences(of: "{{min}}", with: minValue)
                }
                if !ValidationUtils.validMaxValue(number, maxValue: formItem.maxValue) {
                    let maxValue = formItem.maxValue.map { String(Int($0)) } ?? "nil"
                    return viewModel.uiState.translator.t("form.validation.error.default.maxValue.not.met").replacingOccurrences(of: "{{max}}", with: maxValue)
                }
            } catch {
                return viewModel.uiState.translator.t("form.validation.error.default.number.invalid")
            }
        }
        return ""
    }
    
    enum NumberFormatError: Error {
        case invalidNumber
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
            KhipuTextField(
                formItem: formItem1,
                hasNextField: false,
                isValid:  isValid,
                returnValue: returnValue,
                viewModel: viewModel
            )
            KhipuTextField(
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
