import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
public struct KhipuGroupedListField: View {
    var formItem: FormItem
    var isValid: (Bool) -> Void
    var returnValue: (String) -> Void
    var submitFunction: () -> Void
    @State private var selectedTabIndex = 0
    @State private var selectedOption: GroupedOption? = nil
    @State private var textFieldValue = ""
    
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
                .padding(.horizontal, 36)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .padding(.horizontal)
                .overlay(
                    Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.horizontal, 24)
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
                        HStack {
                            AsyncImage(url: URL(string: option.image ?? "")) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                } else if phase.error != nil {
                                    Color.red
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                } else {
                                    Color.gray
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                }
                            }
                            Text(option.name ?? "")
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                    }
                }
            }
            .padding()
            
        }
    }
    
    func filterBankByText(currentList: [GroupedOption], textFieldValue: String) -> [GroupedOption] {
        if textFieldValue.isEmpty {
            return currentList
        } else {
            return currentList.filter {
                $0.name?.localizedCaseInsensitiveContains(textFieldValue) == true
            }
        }
    }
    
    func filterBankByTab(currentList: [GroupedOption]) -> [GroupedOption] {
        return currentList.filter {
            $0.tag == tabs[selectedTabIndex]
        }
    }
}
