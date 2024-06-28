import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct CheckboxField: View {
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
    let bundle = KhipuClientBundleHelper.podBundle
    internal var didAppear: ((Self) -> Void)?

    
    var body: some View {
        VStack(alignment: .leading, spacing:themeManager.selectedTheme.dimens.extraMedium) 
        {
            HStack {
                Toggle(isOn: $isChecked) {
                    Text("Recordar credenciales")
                        .font(themeManager.selectedTheme.fonts.regular12)
                        .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                      .frame(width: 196, height: 17, alignment: .topLeading)
                }
                .accessibilityIdentifier("checkbox")
                .onAppear {
                    isChecked = formItem.defaultState == "on"
                    self.didAppear?(self)
                }
                .toggleStyle(iOSCheckboxToggleStyle())
                .onChange(of: isChecked) { newValue in
                    onChange(newValue: newValue)
                }
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .topLeading)
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
struct CheckboxField_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = KhipuViewModel()
        let isValid: (Bool) -> Void = { param in }
        let returnValue: (String) -> Void = { param in }
        viewModel.uiState = KhipuUiState()
        viewModel.uiState.translator = KhipuTranslator(translations: [:])
        
        let formItem1 = try! FormItem(
                 """
                     {
                       "id": "item1",
                       "label": "item1",
                       "type": "\(FormItemTypes.checkbox.rawValue)",
                       "defaultState": "on"
                     }
                 """
        )
        let formItem2 = try! FormItem(
                 """
                     {
                       "id": "item1",
                       "label": "item1",
                       "type": "\(FormItemTypes.checkbox.rawValue)",
                       "defaultState": "off",
                       "requiredState": "on"
                     }
                 """
        )
        return VStack {
            CheckboxField(
                formItem: formItem1,
                hasNextField: false,
                isValid:  isValid,
                returnValue: returnValue,
                viewModel: viewModel
            )
            CheckboxField(
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
