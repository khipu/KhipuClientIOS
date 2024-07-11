import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct SelectableOption<Content: View>: View  {
    var selected: Bool
    let content: () -> Content
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        
      
        HStack(alignment: .center, spacing: Dimens.Spacing.extraMedium) {
            content()
        }
        .padding(.horizontal, Dimens.Padding.large)
        .padding(.vertical, Dimens.Padding.medium)
        .frame(maxWidth: .infinity, minHeight: Dimens.Frame.substantiallyLarge, maxHeight: Dimens.Frame.substantiallyLarge, alignment: .leading)
        .background(themeManager.selectedTheme.colors.surface)
        .cornerRadius(Dimens.CornerRadius.moderatelySmall)
        .overlay(
        RoundedRectangle(cornerRadius: Dimens.CornerRadius.moderatelySmall)
        .inset(by: 0.5)
        .stroke(selected ? themeManager.selectedTheme.colors.primary : themeManager.selectedTheme.colors.outline, lineWidth: 1)
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
