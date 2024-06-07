import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct KhipuCheckboxField: View {
    var formItem: FormItem
    var hasNextField: Bool
    var isValid: (Bool) -> Void
    var returnValue: (String) -> Void
    @ObservedObject var viewModel: KhipuViewModel
    @State var currentTime: TimeInterval = Date().timeIntervalSince1970
    @State var lastModificationTime: TimeInterval = 0
    @State var error: String = ""
    @State var isChecked: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing:0) {
            HStack {
                Toggle(isOn: $isChecked) {
                    Text(formItem.label ?? "")
                }
                .onAppear {
                    isChecked = formItem.checked ?? false
                }
                .toggleStyle(iOSCheckboxToggleStyle())
                .onChange(of: isChecked) { newValue in
                    onChange(newValue: newValue)
                }
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
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
        error = validateCheckAndMandatory(checked: isChecked, formItem: formItem)
        isValid(error.isEmpty)
        returnValue(String(newValue))
        lastModificationTime = Date().timeIntervalSince1970
    }
    
    func shouldDisplayError() -> Bool {
        return !error.isEmpty && (currentTime - lastModificationTime > 1)
    }
    
    func validateCheckAndMandatory(checked: Bool, formItem: FormItem) -> String {
        if formItem.mandatory == true && !isChecked {
            return viewModel.uiState.translator.t("form.validation.error.default.required")
        }
        return ""
    }
}
