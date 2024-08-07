import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct SwitchField: View {
    var formItem: FormItem
    var hasNextField: Bool
    var isValid: (Bool) -> Void
    var returnValue: (String) -> Void
    @ObservedObject var viewModel: KhipuViewModel
    @State var currentTime: TimeInterval = Date().timeIntervalSince1970
    @State var lastModificationTime: TimeInterval = 0
    @State var error: String = ""
    @State var isChecked: Bool = false
    @EnvironmentObject private var themeManager: ThemeManager
    
    internal var didAppear: ((Self) -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing:0) {
            HStack {
                Toggle(isOn: $isChecked) {
                    FieldLabel(text: formItem.label,font: themeManager.selectedTheme.fonts.font(style: .regular, size: 14), lineSpacing:Dimens.Spacing.medium, paddingBottom:Dimens.Spacing.extraSmall).accessibilityIdentifier("toggleText")
                }
                .accessibilityIdentifier("toggle")
                .onAppear {
                    isChecked = formItem.defaultState == "on"
                    self.didAppear?(self)
                }
                .onChange(of: isChecked) { newValue in
                    onChange(newValue: newValue)
                }
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HintLabel(text: formItem.hint)
            
            if shouldDisplayError() {
                ErrorLabel(text: error)
            }
        }
        .onAppear {
            startTimer()
        }
    }
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            currentTime = Date().timeIntervalSince1970
        }
    }
    
    
    func onChange(newValue: Bool) {
        isChecked = newValue
        error = ValidationUtils.validateCheckRequiredState(isChecked,
                                                           formItem.requiredState,
                                                           viewModel.uiState.translator)
        isValid(error.isEmpty)
        returnValue(String(newValue))
        lastModificationTime = Date().timeIntervalSince1970
    }
    
    func shouldDisplayError() -> Bool {
        return !error.isEmpty && (currentTime - lastModificationTime > 1)
    }
    
}

@available(iOS 15.0, *)
struct KhipuSwitchField_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = KhipuViewModel()
        let isValid: (Bool) -> Void = { param in }
        let returnValue: (String) -> Void = { param in }
        viewModel.uiState = KhipuUiState()
        viewModel.uiState.translator = KhipuTranslator(translations: [:])
        
        return VStack {
            SwitchField(
                formItem: MockDataGenerator.createSwitchFormItem(id: "item1", label: "Do you accept the terms?",defaultState: "off"),
                hasNextField: false,
                isValid:  isValid,
                returnValue: returnValue,
                viewModel: viewModel
            )
            SwitchField(
                formItem: MockDataGenerator.createSwitchFormItem(id: "item1", label: "Do you accept the terms?",defaultState: "on", requiredState: "on"),
                hasNextField: false,
                isValid:  isValid,
                returnValue: returnValue,
                viewModel: viewModel
            )
        }
        .environmentObject(ThemeManager())
    }
}
