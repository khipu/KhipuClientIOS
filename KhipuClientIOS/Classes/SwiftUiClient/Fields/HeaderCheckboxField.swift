import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct HeaderCheckboxField: View {
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
            if !(formItem.title?.isEmpty ?? false) {
                HStack {
                    Text(formItem.title ?? "").accessibilityIdentifier("titleText")
                    Spacer()
                }
                .padding(.vertical)
            }
            HStack {
                Toggle(isOn: $isChecked) {
                    FieldLabel(text: formItem.label,font: themeManager.selectedTheme.fonts.font(style: .regular, size: 14), lineSpacing:Dimens.Spacing.medium, paddingBottom:Dimens.Spacing.extraSmall)                }
                .accessibilityIdentifier("toggle")
                .onAppear {
                    isChecked = formItem.defaultState == "on"
                    self.didAppear?(self)
                }
                .toggleStyle(iOSCheckboxToggleStyle())
                .onChange(of: isChecked) { newValue in
                    onChange(newValue: newValue)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if shouldDisplayError() {
                ErrorLabel(text: error)
            }
            
            if !(formItem.items?.isEmpty ?? true) {
                VStack {
                    ForEach(formItem.items ?? [], id: \.self) {
                        item in
                        HStack {
                            Image(systemName:  "checkmark.square")
                            Text(item)
                        }
                    }
                }
                .accessibilityIdentifier("items")
                .padding()
            }
            
            if !(formItem.bottomText?.isEmpty ?? false) {
                HStack {
                    Text(formItem.bottomText ?? "") .accessibilityIdentifier("bottomText")
                    Spacer()
                }
            }
            
            
        }
        .padding(.horizontal)
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
struct HeaderCheckboxField_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = KhipuViewModel()
        let isValid: (Bool) -> Void = { param in }
        let returnValue: (String) -> Void = { param in }
        viewModel.uiState = KhipuUiState()
        viewModel.uiState.translator = KhipuTranslator(translations: [:])
 
        return VStack {
            HeaderCheckboxField(
                formItem: MockDataGenerator.createCheckboxFormItem(
                    id: "item1",
                    label: "item1",
                    requiredState: "on",
                    defaultState: "off",
                    title: "HeaderCheckbox with title",
                    bottomText: "The bottom text",
                    items: ["item 1", "item 2", "item 3"]
                ),
                hasNextField: false,
                isValid:  isValid,
                returnValue: returnValue,
                viewModel: viewModel
            )
            HeaderCheckboxField(
                formItem: MockDataGenerator.createCheckboxFormItem(
                    id: "item1",
                    label: "item1",
                    requiredState: "on",
                    defaultState: "on",
                    title: "HeaderCheckbox selected",
                    mandatory: true
                ),
                hasNextField: false,
                isValid:  isValid,
                returnValue: returnValue,
                viewModel: viewModel
            )
        }
        .environmentObject(ThemeManager())
    }
}
