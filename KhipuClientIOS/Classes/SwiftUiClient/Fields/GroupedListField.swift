import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
public struct GroupedListField: View {
    var formItem: FormItem
    var isValid: (Bool) -> Void
    var returnValue: (String) -> Void
    var submitFunction: () -> Void
    var noResultsTitle: String
    var noResultsInfo: String
    @State private var selectedTabIndex = 0
    @State private var selectedOption: GroupedOption? = nil
    @State private var textFieldValue = ""
    @FocusState private var isSearchFocused: Bool
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
        VStack(alignment: .center, spacing: Dimens.quiteLarge) {
            HStack(alignment: .top, spacing: 0) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    Button(action: {
                        selectedTabIndex = index
                    }) {
                        VStack(spacing: 0) {
                            Text(tabs[index].uppercased())
                                .font(themeManager.selectedTheme.fonts.font(style: .medium, size: 14))
                                .foregroundColor(selectedTabIndex == index ? themeManager.selectedTheme.colors.info : themeManager.selectedTheme.colors.onSurfaceVariant)
                                .tracking(0.4)
                                .padding(.horizontal, Dimens.extraMedium)
                                .padding(.vertical, 9)
                                .frame(maxWidth: .infinity)

                            // Línea indicadora
                            Rectangle()
                                .fill(selectedTabIndex == index ? themeManager.selectedTheme.colors.info : Color.clear)
                                .frame(height: Dimens.LineHeight.tabIndicator)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }.padding(0)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
            MaterialTextField(
                label: formItem.label ?? "",
                placeholder: formItem.placeHolder ?? "",
                text: $textFieldValue,
                isFocused: $isSearchFocused
            )
            
            if filteredList.isEmpty && !textFieldValue.isEmpty {
                VStack(spacing: Dimens.large) {
                    if let emptyImage = KhipuClientBundleHelper.image(named: "empty-search") {
                        Image(uiImage: emptyImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: Dimens.Image.emptyStateIcon, height: Dimens.Image.emptyStateIcon)
                    }

                    VStack(spacing: 0) {
                        Text(noResultsTitle)
                            .font(themeManager.selectedTheme.fonts.font(style: .regular, size: 16))
                            .foregroundColor(themeManager.selectedTheme.colors.onBackground)
                            .multilineTextAlignment(.center)

                        Text(noResultsInfo)
                            .font(themeManager.selectedTheme.fonts.font(style: .regular, size: 16))
                            .foregroundColor(themeManager.selectedTheme.colors.onSurfaceVariant)
                            .multilineTextAlignment(.center)
                            .padding(.top, Dimens.extraSmall)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, Dimens.quiteLarge)
            } else {
                VStack(spacing: Dimens.veryMedium) {
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
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, Dimens.large)
        .padding(.vertical, 0)
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
            submitFunction: submitFunction,
            noResultsTitle: "Sin coincidencias",
            noResultsInfo: "Intenta buscando otro banco"
        )
        .padding()
        .environmentObject(ThemeManager())
    }
}
