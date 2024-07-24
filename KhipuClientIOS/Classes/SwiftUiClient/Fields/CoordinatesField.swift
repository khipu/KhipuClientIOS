import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct CoordinateInputField: View {
    var formItem: FormItem
    @Binding var coordValue: String
    @EnvironmentObject private var themeManager: ThemeManager
    
    var length: Int
    let nextField: () -> Void
    let updateIndex: () -> Void
    
    var body: some View {
        Group {
            if formItem.secure ?? false {
                SecureField("", text: $coordValue)
            } else {
                TextField("", text: $coordValue)
            }
        }
        .frame(minWidth:Dimens.Frame.quiteLarge, maxWidth:Dimens.Frame.muchLarger)
        .multilineTextAlignment(.center)
        .textFieldStyle(KhipuTextFieldStyle())
        .autocorrectionDisabled(true)
        .textInputAutocapitalization(.never)
        .keyboardType(FieldUtils.getKeyboardType(formItem: formItem))
        .onChange(of: coordValue) { value in
            updateIndex()
            let filtered = (formItem.number ?? false) ? value.filter { $0.isNumber } : value
            if filtered.count <= length {
                coordValue = filtered
                if filtered.count == length {
                    nextField()
                }
            } else {
                coordValue = String(filtered.prefix(2))
            }
        }
    }
}

@available(iOS 15.0, *)
struct CoordinatesField: View {
    
    @State private var states: [String] = ["","",""]
    
    let formItem: FormItem
    let isValid: (Bool) -> Void
    let returnValue: (String) -> Void
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    enum FocusableField: Int, CaseIterable {
        case coord1 = 0
        case coord2 = 1
        case coord3 = 2
    }
    
    @State private var focusedIndex: Int = 0
    @FocusState private var focusedField: FocusableField?
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                ForEach(0..<3, id: \.self) { index in
                    VStack(alignment: .center) {
                        FieldLabel(text: formItem.labels?[index], font: themeManager.selectedTheme.fonts.font(style: .medium, size: 14))
                        
                        CoordinateInputField(formItem: formItem,
                                             coordValue: $states[index],
                                             length: 2,
                                             nextField: {
                            focusedIndex = (focusedIndex + 1) % 3
                            focusedField = FieldUtils.getElement(FocusableField.self, at: focusedIndex)
                        },
                                             updateIndex:  {
                            focusedIndex = index
                            focusedField = FieldUtils.getElement(FocusableField.self, at: focusedIndex)
                        }
                        ).accessibilityIdentifier("coordinateInput\(index + 1)")
                            .focused($focusedField, equals: FieldUtils.getElement(FocusableField.self, at: index))
                    }
                    .accessibilityIdentifier("coordinateItem\(index + 1)")
                }
            }
            HintLabel(text: formItem.hint)
        }
        .padding(.horizontal,Dimens.Padding.extraMedium)
        .onChange(of: states) { _ in
            isValid(states.prefix(3).allSatisfy { $0.count == 2 })
            returnValue(states.prefix(3).joined(separator: "|"))
        }
    }
}

@available(iOS 15.0, *)
struct CoordinatesField_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = KhipuViewModel()
        let isValid: (Bool) -> Void = { param in }
        let returnValue: (String) -> Void = { param in }
        viewModel.uiState = KhipuUiState()
        viewModel.uiState.translator = KhipuTranslator(translations: [:])
        
        return VStack {
            CoordinatesField(
                formItem: MockDataGenerator.createCoordinatesFormItem(
                    id: "item1",
                    labels: ["A1", "A2", "A3"],
                    hint: "Give me the answer",
                    number: false
                ),
                isValid:  isValid,
                returnValue: returnValue
            )
            CoordinatesField(
                formItem: MockDataGenerator.createCoordinatesFormItem(
                    id: "item2",
                    labels: ["Coord1", "Coord2", "Coord3"],
                    number: true
                ),
                isValid:  isValid,
                returnValue: returnValue
            )
            CoordinatesField(
                formItem: MockDataGenerator.createCoordinatesFormItem(
                    id: "item3",
                    labels: ["A", "B", "C"],
                    secure: true
                ),
                isValid:  isValid,
                returnValue: returnValue
            )
        }
        .environmentObject(ThemeManager())
    }
}
