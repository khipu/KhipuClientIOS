import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
public struct GroupedListField: View {
    var formItem: FormItem
    var isValid: (Bool) -> Void
    var returnValue: (String) -> Void
    var submitFunction: () -> Void
    @State private var selectedTabIndex = 0
    @State private var selectedOption: GroupedOption? = nil
    @State private var textFieldValue = ""
    @EnvironmentObject private var themeManager: ThemeManager

    var tabs: [String] {
        formItem.groupedOptions?.tagsOrder?.components(separatedBy: ",") ?? []
    }
    
    var allOptions: [GroupedOption] {
        formItem.groupedOptions?.options ?? []
    }
    
    
    var filteredList: [GroupedOption] {
        filterBankByText(currentList: filterBankByTab(currentList: allOptions), textFieldValue: textFieldValue)
    }
    
    public var body: some View {
        VStack {
            Picker("Tabs", selection: $selectedTabIndex) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    Text(tabs[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            TextField(formItem.placeHolder ?? "", text: $textFieldValue)
                .padding(.vertical)
                .padding(.horizontal,Dimens.Padding.veryLarge)
                .overlay(
                    RoundedRectangle(cornerRadius:Dimens.CornerRadius.extraSmall)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .padding(.horizontal)
                .overlay(
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.horizontal,Dimens.Padding.moderatelyLarge)
                    ,
                    alignment: .leading
                )
            
            
            VStack(spacing: 16) {
                ForEach(filteredList, id: \.value) { option in
                    Button(action: {
                        selectedOption = option
                        isValid(true)
                        returnValue(option.value ?? "")
                        submitFunction()
                    }) {
                        SelectableOption(selected: selectedOption?.value == option.value ) {
                            OptionLabel(image:option.image, text:option.name)
                        }
                    }
                }
            }
            .padding()
            
        }
    }
    
    func filterBankByText(currentList: [GroupedOption], textFieldValue: String) -> [GroupedOption] {
        if textFieldValue.isEmpty {
            return currentList
        }
        
        return currentList.filter {
            $0.name?.localizedCaseInsensitiveContains(textFieldValue) == true
        }
    }
    
    func filterBankByTab(currentList: [GroupedOption]) -> [GroupedOption] {
        return currentList.filter {
            $0.tag == tabs[selectedTabIndex]
        }
    }
}

@available(iOS 15.0, *)
struct GroupedList_Previews: PreviewProvider {
    static var previews: some View {
        let isValid: (Bool) -> Void = { param in }
        let returnValue: (String) -> Void = { param in }
        let submitFunction: () -> Void = {}

        return GroupedListField(
            formItem: MockDataGenerator.createDataTableFormItem(
                id: "item1",
                label: "item1",
                placeholder: "placeholder",
                dataTable: DataTable(
                    rows: [
                        DataTableRow(cells: [
                            DataTableCell(backgroundColor: nil, fontSize: nil, fontWeight: nil, foregroundColor: nil, text: "Cell 1", url: nil)
                        ])
                    ],
                    rowSeparator: nil
                ),
                groupedOptions: GroupedOptions(options: [
                    GroupedOption(image: "https://s3.amazonaws.com/static.khipu.com/logos/bancos/chile/demobank-icon.png", name: "Demo Bank", tag: "Persona", value: "1"),
                    GroupedOption(image: "https://s3.amazonaws.com/static.khipu.com/logos/bancos/chile/demobank-icon.png", name: "Alternative Demo Bank", tag: "Persona", value: "2"),
                    GroupedOption(image: "https://s3.amazonaws.com/static.khipu.com/logos/bancos/chile/demobank-icon.png", name: "Demo Bank Empresa", tag: "Empresa", value: "2")
                ], tagsOrder: "Persona,Empresa")
            ),
            isValid: isValid,
            returnValue: returnValue,
            submitFunction: submitFunction)
        .padding()
        .environmentObject(ThemeManager())
    }
}
