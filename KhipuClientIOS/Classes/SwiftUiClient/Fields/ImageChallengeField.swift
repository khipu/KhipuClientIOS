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
            FieldLabel(text: formItem.label,font: themeManager.selectedTheme.fonts.font(style: .regular, size: 14), lineSpacing:Dimens.Spacing.medium, paddingBottom:Dimens.Spacing.extraSmall)
            
            VStack {
                Image(uiImage:  FieldUtils.loadImageFromBase64(formItem.imageData))
                    .resizable()
                    .scaledToFit()
                    .frame(width:Dimens.Image.gigantic, height:Dimens.Image.gigantic)
                
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
        .padding(.vertical,Dimens.Padding.verySmall)
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
        
        return VStack {
            ImageChallengeField(
                formItem: MockDataGenerator.createImageChallengeFormItem(),
                hasNextField: false,
                isValid:  isValid,
                returnValue: returnValue,
                viewModel: viewModel
            )
        }.environmentObject(ThemeManager())
    }
}
