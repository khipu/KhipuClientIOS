import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct KhipuListField: View {
    let formItem: FormItem
    let isValid: (Bool) -> Void
    let returnValue: (String) -> Void
    let submitFunction: () -> Void
    
    @State private var selectedOption: ListOption?
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: Dimensions.small) {
            FieldLabel(text: formItem.label)
            var a = 0
            ForEach(formItem.options ?? [], id: \.value) { option in
                a = a + 1
                return VStack() {
                    Spacer().frame(height: 3)
                    Button(action: {
                        selectedOption = option
                        isValid(true)
                        returnValue(option.value ?? "")
                        submitFunction()
                    }) {
                        VStack(alignment: .leading, spacing: Dimensions.small) {
                            Text(option.name ?? "")
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            
                            if let dataTable = option.dataTable, !dataTable.rows.isEmpty {
                                KhipuDataTable(dataTable: dataTable).accessibilityIdentifier("dataTable" )
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: themeManager.selectedTheme.dimens.extraSmall)
                                .stroke(themeManager.selectedTheme.colors.onBackground, lineWidth: 0.5)
                        )
                        .accessibilityIdentifier("listItem\(a)" )
                    }
                }
            }
        }
    }
}

struct Dimensions {
    static let small: CGFloat = 8
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
    static let extraLarge: CGFloat = 48
    static let veryLarge: CGFloat = 64
}

@available(iOS 15.0, *)
struct KhipuListField_Previews: PreviewProvider {
    static var previews: some View {
        let isValid: (Bool) -> Void = { param in }
        let returnValue: (String) -> Void = { param in }
        let submitFunction: () -> Void = {}
        let formItem1 = try! FormItem(
         """
           {
            "id": "item1",
            "label": "Select an option",
            "placeholder": "placeholder",
            "type": "\(FormItemTypes.list.rawValue)",
            "options":[
                    {"image": "https://s3.amazonaws.com/static.khipu.com/logos/bancos/chile/demobank-icon.png", "name": "Option 1", "value": "1" },
                    {"image": "https://s3.amazonaws.com/static.khipu.com/logos/bancos/chile/demobank-icon.png", "name": "Option 2", "value": "2" },
                    {"image": "https://s3.amazonaws.com/static.khipu.com/logos/bancos/chile/demobank-icon.png", "name": "Option with datatable", "value": "3", "dataTable": {"rows":[{"cells":[{"text":"Cell 1"}]}], "rowSeparator":{}}}
            ]
            }
           
         """
        )
        return KhipuListField(
            formItem: formItem1,
            isValid: isValid,
            returnValue: returnValue,
            submitFunction: submitFunction
        )
        .padding()
        .environmentObject(ThemeManager())
    }
}
