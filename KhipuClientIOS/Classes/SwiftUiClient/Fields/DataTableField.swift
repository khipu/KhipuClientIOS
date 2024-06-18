import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct DataTableField: View {
    var formItem: FormItem
    var hasNextField: Bool
    var isValid: (Bool) -> Void
    var returnValue: (String) -> Void
    @State var passwordVisible: Bool = false
    @State var textFieldValue: String = ""
    
    var body: some View {
        DataTableCommon(dataTable: formItem.dataTable!)
    }
}

@available(iOS 15.0, *)
struct DataTableField_Previews: PreviewProvider {
    static var previews: some View {
        let isValid: (Bool) -> Void = { param in }
        let returnValue: (String) -> Void = { param in }
        let formItem1 = try! FormItem(
         """
           {
            "id": "item1",
            "label": "item1",
            "type": "\(FormItemTypes.dataTable.rawValue)",
            "dataTable": {"rows":[], "rowSeparator":{}}
           }
         """
        )
        let formItem2 = try! FormItem(
         """
           {
            "id": "item1",
            "label": "item1",
            "type": "\(FormItemTypes.dataTable.rawValue)",
            "dataTable": {"rows":[{"cells":[{"text":"Cell 1"}]}], "rowSeparator":{}}
           }
         """
        )
        
        let formItem3 = try! FormItem(
        """
            {
            "id": "item1",
            "label": "item1",
            "type":"\(FormItemTypes.dataTable.rawValue)",
            "dataTable": {
                "rows":[
                    {"cells":[
                        {"text":"Cell 1"},
                        {"text":"Cell 2"},
                        {"text":"Cell 3"}
                    ]},
                    {"cells":[
                        {"text":"Cell 1"},
                        {"text":"Cell 2"}
                    ]}
                ], "rowSeparator":{}}
            }
        """
        )
        return VStack {
            Text("DataTable empty:")
            DataTableField(
                formItem: formItem1,
                hasNextField: false,
                isValid: isValid,
                returnValue: returnValue
            )
            Text("DataTable one cell:")
            DataTableField(
                formItem: formItem2,
                hasNextField: false,
                isValid: isValid,
                returnValue: returnValue
            )
            Text("DataTable two rows:")
            DataTableField(
                formItem: formItem3,
                hasNextField: false,
                isValid: isValid,
                returnValue: returnValue
            )
        }
    }
}
