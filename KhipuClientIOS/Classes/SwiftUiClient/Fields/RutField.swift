import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct RutField: View {
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
    @FocusState private var isFocused: Bool
    
    var body: some View {
        
        VStack(alignment: .leading, spacing:0) {
            FieldLabel(text: formItem.label,font: themeManager.selectedTheme.fonts.font(style: .regular, size: 14), lineSpacing:Dimens.Spacing.medium, paddingBottom: Dimens.Spacing.extraSmall)
            TextField(formItem.placeHolder ?? "", text: $rutValue)
                .textFieldStyle(KhipuTextFieldStyle())
                .autocorrectionDisabled(true)
                .focused($isFocused)
                .textInputAutocapitalization(.never)
                .keyboardType(FieldUtils.getKeyboardType(formItem: formItem))
                .multilineTextAlignment(.leading)
                .overlay(
                    RoundedRectangle(cornerRadius: Dimens.CornerRadius.extraSmall)
                        .stroke(isFocused ? themeManager.selectedTheme.colors.primary : themeManager.selectedTheme.colors.outline, lineWidth: 1)
                )
                .onChange(of: rutValue) { newValue in
                    onChange(newValue: newValue)
                }
                .customKeyboard(.rutKeyboard)
                .onAppear {
                    if viewModel.uiState.currentForm?.rememberValues ?? false {
                        rutValue = viewModel.uiState.storedUsername
                    }
                }
            
            HintLabel(text: formItem.hint)
            
            if shouldDisplayError() {
                ErrorLabel(text: error)
            }
        }
        .padding(.vertical,Dimens.Padding.verySmall)
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
        error = ValidationUtils.validateRut(newValue, viewModel.uiState.translator)
        isValid(error.isEmpty)
        returnValue(newValue)
        lastModificationTime = Date().timeIntervalSince1970
    }
}

@available(iOS 15.0.0, *)
struct LabeledButton: View {
    let text: String
    let textDocumentProxy: UITextDocumentProxy
    let playSystemFeedback: (() -> ())?
    let bundle = KhipuClientBundleHelper.podBundle
    
    var body: some View {
        Button {
            textDocumentProxy.insertText(text)
            playSystemFeedback?()
        }
    label: {
        Text(text)
            .font(.system(size: 24))
            .padding(.all, 9)
            .background(Color("background", bundle: bundle))
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color("background", bundle: bundle))
    .foregroundColor(Color("onBackground", bundle: bundle))
    .cornerRadius(6)
    .shadow(radius: 0, y: 1)
    }
}

@available(iOS 15.0.0, *)
struct ImageButton: View {
    let bundle = KhipuClientBundleHelper.podBundle
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
        .foregroundColor(Color("onBackground", bundle: bundle))
    }
}

class MockTextDocumentProxy: NSObject, UITextDocumentProxy {
    var documentContextBeforeInput: String?
    var documentContextAfterInput: String?
    var selectedText: String?
    var documentInputMode: UITextInputMode?
    var documentIdentifier: UUID
    var hasText: Bool
    func adjustTextPosition(byCharacterOffset offset: Int) {}
    func setMarkedText(_ markedText: String, selectedRange: NSRange) {}
    func unmarkText() {}
    func insertText(_ text: String) {}
    func deleteBackward() {}
    
    override init() {
        self.documentIdentifier = UUID()
        self.selectedText = "abcdef"
        self.hasText = true
        super.init()
    }
    
}


@available(iOS 15.0.0, *)
struct KhipuRutField_Previews: PreviewProvider {
    static var previews: some View {
        
        let isValid: (Bool) -> Void = { param in }
        let returnValue: (String) -> Void = { param in }
        return RutField(
            formItem: MockDataGenerator.createTextFormItem(label: "Label", hint: "Enter some text", placeHolder: "Ex: my text"),
            hasNextField: false,
            isValid: isValid,
            returnValue: returnValue,
            rutValue: "",
            error: "Error message",
            lastModificationTime: TimeInterval.pi,
            viewModel: KhipuViewModel(),
            currentTime: TimeInterval.pi
        )
        .environmentObject(ThemeManager())
        .padding()
    }
}
