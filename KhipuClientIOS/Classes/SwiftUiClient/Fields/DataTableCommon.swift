import SwiftUI
import KhenshinProtocol

@available(iOS 15.0.0, *)
struct DataTableCommon: View {
    
    @EnvironmentObject private var themeManager: ThemeManager

    let dataTable: DataTable
    
    var body: some View {
        let maxCells = FieldUtils.getMaxDataTableCells(dataTable)
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(dataTable.rows.enumerated()), id: \.offset) { row in
                HStack(spacing: 0) {
                    ForEach(0..<maxCells, id: \.self) { index in
                        if index < row.element.cells.count {
                            let cell = row.element.cells[index]
                            Text(cell.text)
                                .foregroundColor(themeManager.selectedTheme.colors.secondary)
                                .font(themeManager.selectedTheme.fonts.font(style: .medium, size: 14))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            Text("").font(themeManager.selectedTheme.fonts.font(style: .medium, size: 14))
                            .frame(maxWidth: .infinity)                        }
                    }
                }
            }
        }
        .padding(0)
        .frame(maxWidth: .infinity, alignment: .topLeading)    }
}



@available(iOS 15.0, *)
struct DataTableCommon_Previews: PreviewProvider {
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
        
        return DataTableCommon(dataTable: mockDataTable)
            .environmentObject(ThemeManager())
            .padding()
    }
}
