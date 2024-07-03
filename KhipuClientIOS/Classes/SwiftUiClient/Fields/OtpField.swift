import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct OtpField: View {
    @State private var states: [String] = ["","","", "", "", ""]
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var focusedIndex: Int = 0
    @FocusState private var focusedField: FocusableField?
    
    let formItem: FormItem
    let isValid: (Bool) -> Void
    let returnValue: (String) -> Void
    
    enum FocusableField: Int, CaseIterable {
        case coord1 = 0
        case coord2 = 1
        case coord3 = 2
        case coord4 = 3
        case coord5 = 4
        case coord6 = 5
    }
    
    var body: some View {
        let count: Int = min(Int(formItem.length ?? 0), 6)
        VStack {
            FieldLabel(text: formItem.label,font: themeManager.selectedTheme.fonts.font(style: .regular, size: 14), lineSpacing: themeManager.selectedTheme.dimens.medium, paddingBottom: themeManager.selectedTheme.dimens.extraSmall)
            HStack(spacing: themeManager.selectedTheme.dimens.extraMedium) {
                var a = 0
                ForEach(0..<count, id: \.self) { index in
                    a = a + 1
                    return VStack(alignment: .center) {
                        CoordinateInputField(formItem: formItem,
                                             coordValue: $states[index],
                                             length: 1,
                                             nextField: {
                            focusedIndex = (focusedIndex + 1) % count
                            focusedField = FieldUtils.getElement(FocusableField.self, at: focusedIndex)
                        },
                                             updateIndex:  {
                            focusedIndex = index
                            focusedField = FieldUtils.getElement(FocusableField.self, at: focusedIndex)
                        }
                        )
                        .accessibilityIdentifier("coordinateInput\(a)")
                        .focused($focusedField,   equals: FieldUtils.getElement(FocusableField.self, at: index))
                    }
                }
            }
            HintLabel(text: formItem.hint)
        }
        
        .padding(.horizontal, themeManager.selectedTheme.dimens.extraMedium)
        .onChange(of: states) { _ in
            isValid(states.prefix(count).allSatisfy { $0.count == 1 })
            returnValue(states.prefix(count).joined(separator: "|"))
        }
    }
}

@available(iOS 15.0, *)
struct KhipuOtpField_Previews: PreviewProvider {
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
                       "label": "Type your DIGIPASS with numbers",
                       "length": 4,
                       "type": "\(FormItemTypes.otp.rawValue)",
                       "hint": "Give me the answer",
                       "number": false,
                     }
                 """
        )
        let formItem2 = try! FormItem(
                 """
                     {
                       "id": "item2",
                       "label": "Type your alphanumeric otp",
                       "length": 5,
                       "type": "\(FormItemTypes.otp.rawValue)",
                       "number" : false
                     }
                 """
        )
        let formItem3 = try! FormItem(
                 """
                     {
                       "id": "item3",
                       "label": "Type your alphanumeric otp secure",
                       "length": 6,
                       "type": "\(FormItemTypes.otp.rawValue)",
                       "secure" : true
                     }
                 """
        )
        return VStack {
            OtpField(
                formItem: formItem1,
                isValid:  isValid,
                returnValue: returnValue
            )
            OtpField(
                formItem: formItem2,
                isValid:  isValid,
                returnValue: returnValue
            )
            OtpField(
                formItem: formItem3,
                isValid:  isValid,
                returnValue: returnValue
            )
        }
        .environmentObject(ThemeManager())
    }
}
