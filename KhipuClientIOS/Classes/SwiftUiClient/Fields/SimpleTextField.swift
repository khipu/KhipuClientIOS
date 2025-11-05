import SwiftUI
import KhenshinProtocol

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
        VStack(alignment: .leading, spacing: 4) {
            MaterialTextField(
                label: formItem.label ?? "",
                placeholder: formItem.placeHolder ?? "",
                text: $textFieldValue,
                isSecure: (formItem.secure == true) && !passwordVisible,
                keyboardType: FieldUtils.getKeyboardType(formItem: formItem),
                trailingIcon: getTrailingIcon(),
                onTrailingIconTap: formItem.secure == true ? {
                    passwordVisible.toggle()
                } : nil,
                isFocused: $isFocused
            )
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

    func getTrailingIcon() -> String? {
        if formItem.secure == true {
            return passwordVisible ? "eye" : "eye.slash"
        }
        return nil
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
