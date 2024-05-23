import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct KhipuRutField: View {
    var formItem: FormItem
    var hasNextField: Bool
    var isValid: (Bool) -> Void
    var returnValue: (String) -> Void
    @State var rutValue: String = ""
    @State var error: String = ""
    @State var lastModificationTime: TimeInterval = 0
    @ObservedObject var viewModel: KhipuViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State var currentTime: TimeInterval = Date().timeIntervalSince1970
    
    var body: some View {
        VStack(alignment: .leading, spacing:0) {
            FieldLabel(text: formItem.label)
            TextField(formItem.placeHolder ?? "", text: $rutValue)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .keyboardType(FieldUtils.getKeyboardType(formItem: formItem))
                .multilineTextAlignment(.leading)
                .onChange(of: rutValue) { newValue in
                    onChange(newValue: newValue)
                }
                .customKeyboard(.rutKeyboard)
            
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
        }
    }
    
    func shouldDisplayError() -> Bool {
        return !error.isEmpty && (currentTime - lastModificationTime > 1)
    }
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            currentTime = Date().timeIntervalSince1970
        }
    }
    
    private func onChange(newValue: String) {
        rutValue = newValue
        error = validateRutField(value: newValue, formItem: formItem)
        isValid(error.isEmpty)
        returnValue(newValue)
        lastModificationTime = Date().timeIntervalSince1970
    }
    
    private func validateRutField(value: String, formItem: FormItem) -> String {
        if value.isEmpty {
            return viewModel.uiState.translator.t("form.validation.error.rut.nullable")
        }
        if (!ValidationUtils.isValidRut(value)){
            return viewModel.uiState.translator.t("form.validation.error.rut.invalid")
        }
        return ""
    }
}


@available(iOS 15.0, *)
extension CustomKeyboard {
    static var rutKeyboard: CustomKeyboard {
        CustomKeyboardBuilder { textDocumentProxy, submit, playSystemFeedback in
            HStack {
                VStack {
                    LabeledButton(text: "1", textDocumentProxy: textDocumentProxy, playSystemFeedback: playSystemFeedback)
                    LabeledButton(text: "4", textDocumentProxy: textDocumentProxy, playSystemFeedback: playSystemFeedback)
                    LabeledButton(text: "7", textDocumentProxy: textDocumentProxy, playSystemFeedback: playSystemFeedback)
                    LabeledButton(text: "K", textDocumentProxy: textDocumentProxy, playSystemFeedback: playSystemFeedback)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                VStack {
                    LabeledButton(text: "2", textDocumentProxy: textDocumentProxy, playSystemFeedback: playSystemFeedback)
                    LabeledButton(text: "5", textDocumentProxy: textDocumentProxy, playSystemFeedback: playSystemFeedback)
                    LabeledButton(text: "8", textDocumentProxy: textDocumentProxy, playSystemFeedback: playSystemFeedback)
                    LabeledButton(text: "0", textDocumentProxy: textDocumentProxy, playSystemFeedback: playSystemFeedback)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                VStack {
                    LabeledButton(text: "3", textDocumentProxy: textDocumentProxy, playSystemFeedback: playSystemFeedback)
                    LabeledButton(text: "6", textDocumentProxy: textDocumentProxy, playSystemFeedback: playSystemFeedback)
                    LabeledButton(text: "9", textDocumentProxy: textDocumentProxy, playSystemFeedback: playSystemFeedback)
                    ImageButton(imageName: "delete.left", textDocumentProxy: textDocumentProxy, playSystemFeedback: playSystemFeedback)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.all, 6)
            .padding(.bottom, 36)
        }
            
        
    }
}


@available(iOS 15.0.0, *)
struct LabeledButton: View {
    let text: String
    let textDocumentProxy: UITextDocumentProxy
    let playSystemFeedback: (() -> ())?
    let bundle = Bundle(identifier: "org.cocoapods.khenshinClientIos")
    
    var body: some View {
        Button {
            textDocumentProxy.insertText(text)
            playSystemFeedback?()
        }
        label: {
            Text(text)
                .font(.system(size: 24))
                .padding(.all, 9)
                .background(Color("buttonBackground", bundle: bundle))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("buttonBackground", bundle: bundle))
        .foregroundColor(Color("buttonForeground", bundle: bundle))
        .cornerRadius(6)
        .shadow(radius: 0, y: 1)
    }
}

@available(iOS 15.0.0, *)
struct ImageButton: View {
    let bundle = Bundle(identifier: "org.cocoapods.khenshinClientIos")
    let imageName: String
    let textDocumentProxy: UITextDocumentProxy
    let playSystemFeedback: (() -> ())?
    
    var body: some View {
        Button {
            textDocumentProxy.deleteBackward()
            playSystemFeedback?()
            
        } label: {
            Image(systemName: imageName)
                .imageScale(.large)
                .padding(.all, 9)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(Color("buttonForeground", bundle: bundle))
    }
}
