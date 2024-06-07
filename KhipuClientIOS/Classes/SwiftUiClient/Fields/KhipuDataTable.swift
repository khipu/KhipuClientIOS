import SwiftUI
import KhenshinProtocol

@available(iOS 15.0.0, *)
struct KhipuDataTable: View {
    let dataTable: DataTable
    
    var body: some View {
        let maxCells = FieldUtils.getMaxDataTableCells(dataTable)
        VStack {
            ForEach(Array(dataTable.rows.enumerated()), id: \.offset) { row in
                HStack {
                    ForEach(0..<maxCells, id: \.self) { index in
                        if index < row.element.cells.count {
                            let cell = row.element.cells[index]
                            Text(cell.text)
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                                .font(.body)
                                .frame(maxWidth: .infinity)
                        } else {
                            Spacer()
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
    }
}

//struct FieldUtils {
//    static func getMaxDataTableCells(dataTable: DataTable) -> Int {
//        return dataTable.rows?.max(by: { $0.cells.count < $1.cells.count })?.cells.count ?? 0
//    }
//}
//
//struct DataTable {
//    let rows: [Row]?
//}
//
//struct Row {
//    let cells: [Cell]
//}
//
//struct Cell {
//    let text: String
//}



@available(iOS 15.0, *)
struct KhipuDataTable_Previews: PreviewProvider {
    static var previews: some View {
        let mockRowSeparator = RowSeparator(color: nil, height: nil)
        let mockDataTable = DataTable(rows: [
            DataTableRow(cells: [
                DataTableCell(backgroundColor: nil, fontSize: nil, fontWeight: nil, foregroundColor: nil, text: "Cell 1", url: nil),
                DataTableCell(backgroundColor: nil, fontSize: nil, fontWeight: nil, foregroundColor: nil, text: "Cell 2", url: nil),
                DataTableCell(backgroundColor: nil, fontSize: nil, fontWeight: nil, foregroundColor: nil, text: "Cell 3", url: nil)
            ]),
            DataTableRow(cells: [
                DataTableCell(backgroundColor: nil, fontSize: nil, fontWeight: nil, foregroundColor: nil, text: "Cell 1", url: nil),
                DataTableCell(backgroundColor: nil, fontSize: nil, fontWeight: nil, foregroundColor: nil, text: "Cell 2", url: nil)
            ]),
            DataTableRow(cells: [
                DataTableCell(backgroundColor: nil, fontSize: nil, fontWeight: nil, foregroundColor: nil, text: "Cell 1", url: nil)
            ])
        ], rowSeparator: mockRowSeparator)
        
        return KhipuDataTable(dataTable: mockDataTable)
            .previewLayout(.sizeThatFits)
    }
}
