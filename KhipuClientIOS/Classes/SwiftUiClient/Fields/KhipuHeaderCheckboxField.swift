import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct KhipuHeaderCheckboxField: View {
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
            if !(formItem.title?.isEmpty ?? false) {
                HStack {
                    Text(formItem.title ?? "")
                    Spacer()
                }
            }
            HStack {
                Toggle(isOn: $isChecked) {
                    Text((formItem.label ?? ""))
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
            .frame(maxWidth: .infinity, alignment: .leading)

            if !(formItem.items?.isEmpty ?? true) {
                Text("TODO: agregar los items cuando sean una lista")
            }
            
            if !(formItem.bottomText?.isEmpty ?? false) {
                HStack {
                    Text(formItem.bottomText ?? "")
                    Spacer()
                }
            }
            
            if shouldDisplayError() {
                ErrorLabel(text: error)
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
        error = ValidationUtils.validateCheckAndMandatory(isChecked, 
                                                          formItem.mandatory,
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
struct KhipuHeaderCheckboxField_Previews: PreviewProvider {
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
                       "title": "HeaderCheckbox with title",
                       "items": "some checked items",
                       "bottomText": "The bottom text",
                       "type": "\(FormItemTypes.headerCheckbox.rawValue)",
                       "checked": false
                     }
                 """
        )
        let formItem2 = try! FormItem(
                 """
                     {
                       "id": "item1",
                       "label": "item1",
                        "title": "HeaderCheckbox selected",
                        "mandatory": true,
                       "type": "\(FormItemTypes.headerCheckbox.rawValue)",
                       "checked": true
                     }
                 """
        )
        return VStack {
            KhipuHeaderCheckboxField(
                formItem: formItem1,
                hasNextField: false,
                isValid:  isValid,
                returnValue: returnValue,
                viewModel: viewModel
            )
            KhipuHeaderCheckboxField(
                formItem: formItem2,
                hasNextField: false,
                isValid:  isValid,
                returnValue: returnValue,
                viewModel: viewModel
            )
        }
    }
}
