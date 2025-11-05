import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct SelectableOption<Content: View>: View  {
    var selected: Bool
    let content: () -> Content
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack(alignment: .center, spacing: Dimens.extraMedium) {
            content()
        }
        .padding(.horizontal, Dimens.large)
        .padding(.vertical, Dimens.medium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(themeManager.selectedTheme.colors.surface)
        .cornerRadius(Dimens.CornerRadius.moderatelySmall)
        .overlay(
            RoundedRectangle(cornerRadius: Dimens.CornerRadius.moderatelySmall)
                .stroke(themeManager.selectedTheme.colors.outline, lineWidth: 1)
        )
    }
}


@available(iOS 15.0, *)
struct ListOption_Previews: PreviewProvider {
    static var previews: some View {
        
        let mockRowSeparator = RowSeparator(color: nil, height: 0)
        let mockDataTable = DataTable(rows: [
            DataTableRow(cells: [
                DataTableCell(backgroundColor: nil, fontSize: nil, fontWeight: nil, foregroundColor: nil, text: "Disponible $1.000.000", url: nil)
            ]),
        ], rowSeparator: mockRowSeparator)
        
        
        return  VStack(alignment: .leading, spacing: 0) {
            SelectableOption(selected: true) {
                VStack(alignment: .leading, spacing: 0) {
                    OptionLabel(text:"Cuenta Corriente  N° 001002344")
                    DataTableCommon(dataTable: mockDataTable)
                }
            }
            SelectableOption(selected: false) {
                VStack {
                    OptionLabel(text:"Cuenta RUT  N° 15068412")

                }
            }
            
        }.padding(0)
         .frame(maxWidth: .infinity, alignment: .topLeading)
        .environmentObject(ThemeManager())
    }
}
