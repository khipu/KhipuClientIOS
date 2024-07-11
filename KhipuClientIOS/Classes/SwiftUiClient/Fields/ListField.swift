import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct ListField: View {
    let formItem: FormItem
    let isValid: (Bool) -> Void
    let returnValue: (String) -> Void
    let submitFunction: () -> Void
    
    @State private var selectedOption: ListOption?
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing:Dimens.Spacing.small) {
            var a = 0
            ForEach(formItem.options ?? [], id: \.value) { option in
                a = a + 1
                return VStack() {
                    Button(action: {
                        selectedOption = option
                        isValid(true)
                        returnValue(option.value ?? "")
                        submitFunction()
                    }) {
                        SelectableOption(selected: selectedOption?.value == option.value) {
                            VStack(alignment: .leading, spacing: 0) {
                                OptionLabel(image:option.image, text:option.name)
                               
                                if let dataTable = option.dataTable, FieldUtils.getMaxDataTableCells(dataTable) > 0 {
                                    DataTableCommon(dataTable: dataTable).accessibilityIdentifier("dataTable" )
                                }
                            }
                        }.padding(0)
                            .frame(maxWidth: .infinity, alignment: .topLeading).accessibilityIdentifier("listItem\(a)")
                    }
                }
            }
        }
    }
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
        
        return ListField(
            formItem: formItem1,
            isValid: isValid,
            returnValue: returnValue,
            submitFunction: submitFunction
        )
        .padding()
        .environmentObject(ThemeManager())
    }
}



@available(iOS 15.0, *)
struct KhipuListFieldNoImage_Previews: PreviewProvider {
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
                    { "name": "Option 1", "value": "1" },
                    { "name": "Option 2", "value": "2" },
                    { "name": "Option with datatable", "value": "3", "dataTable": {"rows":[{"cells":[{"text":"Cell 1"}]}], "rowSeparator":{}}}
            ]
            }
           
         """
        )
        
        return ListField(
            formItem: formItem1,
            isValid: isValid,
            returnValue: returnValue,
            submitFunction: submitFunction
        )
        .padding()
        .environmentObject(ThemeManager())
    }
}
