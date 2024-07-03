import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct ImageChallengeField: View {
    var formItem: FormItem
    var hasNextField: Bool
    var isValid: (Bool) -> Void
    var returnValue: (String) -> Void
    @ObservedObject var viewModel: KhipuViewModel
    
    @State var value: String = ""
    @State var error: String = ""
    @State var lastModificationTime: TimeInterval = 0
    @EnvironmentObject private var themeManager: ThemeManager
    @State var currentTime: TimeInterval = Date().timeIntervalSince1970
    @State private var image: UIImage? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing:0) {
            FieldLabel(text: formItem.label,font: themeManager.selectedTheme.fonts.font(style: .regular, size: 14), lineSpacing: themeManager.selectedTheme.dimens.medium, paddingBottom: themeManager.selectedTheme.dimens.extraSmall)
            
            VStack {
                Image(uiImage:  FieldUtils.loadImageFromBase64(formItem.imageData))
                    .resizable()
                    .scaledToFit()
                    .frame(width: themeManager.selectedTheme.dimens.gigantic, height: themeManager.selectedTheme.dimens.gigantic)
                
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            TextField(formItem.placeHolder ?? "", text: $value)
                .textFieldStyle(KhipuTextFieldStyle())
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .keyboardType(FieldUtils.getKeyboardType(formItem: formItem))
                .multilineTextAlignment(.leading)
                .onChange(of: value) { newValue in
                    onChange(newValue: newValue)
                }
            
            HintLabel(text: formItem.hint)
            
            if shouldDisplayError() {
                ErrorLabel(text: error)
            }
        }
        .padding(.vertical, themeManager.selectedTheme.dimens.verySmall)
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
        error = validateImageChallenge(value: newValue, formItem: formItem, translator: viewModel.uiState.translator)
        isValid(error.isEmpty)
        returnValue(newValue)
        lastModificationTime = Date().timeIntervalSince1970
    }
    
    private func validateImageChallenge(
        value: String,
        formItem: FormItem,
        translator: KhipuTranslator
    ) -> String {
        if value.isEmpty {
            return translator.t("form.validation.error.default.empty")
        }
        if (!ValidationUtils.validMinLength(value, minLength: formItem.minLength)) {
            return translator.t("form.validation.error.default.minLength.not.met")
                .replacingOccurrences(of: "{{minLength}}", with: String(formItem.minLength ?? 0))
        }
        if (!ValidationUtils.validMaxLength(value, maxLength: formItem.maxLength)) {
            return translator.t("form.validation.error.default.maxLength.exceeded")
                .replacingOccurrences(of: "{{maxLength}}", with: String(formItem.maxLength ?? 0))
        }
        return ""
    }
    
}

@available(iOS 15.0, *)
struct ImageChallengeField_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = KhipuViewModel()
        let isValid: (Bool) -> Void = { param in }
        let returnValue: (String) -> Void = { param in }
        viewModel.uiState = KhipuUiState()
        viewModel.uiState.translator = KhipuTranslator(translations: [:])
        
        let formItem = try! FormItem(
                 """
                     {
                       "id": "item1",
                       "label": "The great Image Challenge",
                       "placeHolder": "It is a khipu",
                       "imageData": "data:image/png;base64,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",
                       "type": "\(FormItemTypes.imageChallenge.rawValue)",
                       "hint": "This is mandatory"
                     }
                 """
        )
        
        return VStack {
            ImageChallengeField(
                formItem: formItem,
                hasNextField: false,
                isValid:  isValid,
                returnValue: returnValue,
                viewModel: viewModel
            )
        }.environmentObject(ThemeManager())
    }
}
