import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct KhipuCoordinatesField: View {
    @State private var coord1: String = ""
    @State private var coord2: String = ""
    @State private var coord3: String = ""
    
    let formItem: FormItem
    let isValid: (Bool) -> Void
    let returnValue: (String) -> Void
    let submitFunction: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    enum FocusableField: Hashable, CaseIterable {
        case coord1, coord2, coord3
    }
    
    @FocusState private var focusedField: FocusableField?
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                VStack(alignment: .center) {
                    FieldLabel(text: formItem.labels?[0])
                    SecureField("", text: $coord1)
                        .frame(minWidth: 30, maxWidth: 80)
                        .padding(.trailing, 8)
                        .onChange(of: coord1) { value in
                            if value.count <= 2 {
                                coord1 = value
                                if value.count == 2 {
                                    focusedField = .coord2
                                }
                            }
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($focusedField, equals: FocusableField.coord1)
                        .multilineTextAlignment(.center)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .keyboardType(FieldUtils.getKeyboardType(formItem: formItem))
                }
                
                VStack(alignment: .center) {
                    FieldLabel(text: formItem.labels?[1])
                    SecureField("", text: $coord2)
                        .frame(minWidth: 30, maxWidth: 90)
                        .padding(.horizontal, 8)
                        .onChange(of: coord2) { value in
                            if value.count <= 2 {
                                coord2 = value
                                if value.count == 2 {
                                    focusedField = .coord3
                                }
                            }
                            
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($focusedField, equals: FocusableField.coord2)
                        .multilineTextAlignment(.center)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .keyboardType(FieldUtils.getKeyboardType(formItem: formItem))
                }
                
                VStack(alignment: .center) {
                    FieldLabel(text: formItem.labels?[2])
                    SecureField("", text: $coord3)
                        .frame(minWidth: 30, maxWidth: 80)
                        .padding(.leading, 8)
                        .onChange(of: coord3) { value in
                            if value.count <= 2 {
                                coord3 = value
                            }
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($focusedField, equals: FocusableField.coord3)
                        .multilineTextAlignment(.center)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .keyboardType(FieldUtils.getKeyboardType(formItem: formItem))
                    }
                    
                }
            }
            .padding(.horizontal, 16)
            .onChange(of: [coord1, coord2, coord3]) { _ in
                let valid = coord1.count == formItem.labels?[0].count && coord2.count == formItem.labels?[1].count && coord3.count == formItem.labels?[2].count
                isValid(valid)
                returnValue("\(coord1)|\(coord2)|\(coord3)")
                submitFunction()
            }
    }
}

