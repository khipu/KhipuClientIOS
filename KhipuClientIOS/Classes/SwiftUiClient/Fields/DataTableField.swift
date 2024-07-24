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

        return VStack {
            Text("DataTable empty:")
            DataTableField(
                formItem: MockDataGenerator.createDataTableFormItem(
                    id: "item1",
                    label: "item1",
                    dataTable: DataTable(
                        rows: [
                            DataTableRow(cells: [
                            ])
                        ],
                        rowSeparator: nil
                    )
                ),
                hasNextField: false,
                isValid: isValid,
                returnValue: returnValue
            ).environmentObject(ThemeManager())

            Text("DataTable one cell:")
            DataTableField(
                formItem: MockDataGenerator.createDataTableFormItem(
                    id: "item1",
                    label: "item1",
                    dataTable: DataTable(
                        rows: [
                            DataTableRow(cells: [
                                DataTableCell(backgroundColor: nil, fontSize: nil, fontWeight: nil, foregroundColor: nil, text: "Cell 1", url: nil)
                            ])
                        ],
                        rowSeparator: nil
                    )
                ),
                hasNextField: false,
                isValid: isValid,
                returnValue: returnValue
            ).environmentObject(ThemeManager())

            Text("DataTable two rows:")
            DataTableField(
                formItem: MockDataGenerator.createDataTableFormItem(
                    id: "item1",
                    label: "item1",
                    dataTable: DataTable(
                        rows: [
                            DataTableRow(cells: [
                                DataTableCell(backgroundColor: nil, fontSize: nil, fontWeight: nil, foregroundColor: nil, text: "Cell 1", url: nil),
                                DataTableCell(backgroundColor: nil, fontSize: nil, fontWeight: nil, foregroundColor: nil, text: "Cell 2", url: nil)
                            ]),
                            DataTableRow(cells: [
                                DataTableCell(backgroundColor: nil, fontSize: nil, fontWeight: nil, foregroundColor: nil, text: "Cell 1", url: nil),
                                DataTableCell(backgroundColor: nil, fontSize: nil, fontWeight: nil, foregroundColor: nil, text: "Cell 2", url: nil),
                                DataTableCell(backgroundColor: nil, fontSize: nil, fontWeight: nil, foregroundColor: nil, text: "Cell 3", url: nil)
                            ])
                        ],
                        rowSeparator: RowSeparator(color: "#D9D9D9", height:1)
                    )
                ),
                hasNextField: false,
                isValid: isValid,
                returnValue: returnValue
            ).environmentObject(ThemeManager())

        }
    }
}
