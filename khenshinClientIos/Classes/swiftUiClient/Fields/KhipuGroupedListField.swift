//
//  TextField.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 09-05-24.
//

import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
public struct KhipuGroupedListField: View {
    var formItem: FormItem
    var hasNextField: Bool
    var isValid: (Bool) -> Void
    var returnValue: (String) -> Void
    @State private var selectedTab: String = ""
    //@State private var selectedOptions: [GroupedOption] = []
    @State private var selectedOption: String = ""
    @State private var optionsFilter: String = ""
    //var tags: [String] = []
    
    //public init(formItem: FormItem, hasNextField: Bool, isValid: @escaping (Bool) -> Void, returnValue: @escaping (String) -> Void) {
    //    self.formItem = formItem
    //    self.hasNextField = hasNextField
    //    self.isValid = isValid
    //    self.returnValue = returnValue
    //    self.tags = formItem.groupedOptions?.tagsOrder?.split(separator: ",") as? [String] ?? []
    //
    //}
    
    public var body: some View {
        let tags = formItem.groupedOptions?.tagsOrder?.components(separatedBy: ",") ?? []
        let options = formItem.groupedOptions?.options?.filter {
            $0.tag == selectedTab && (optionsFilter.isEmpty || (($0.name!.lowercased().contains(optionsFilter.lowercased()))))
        } ?? []
        Picker("", selection: $selectedTab) {
            ForEach(tags, id: \.self) { tag in
                Text(tag).tag(tag)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .onAppear(perform: {
            selectedTab = String(tags.first ?? "")
        })
        TextField("Buscar", text: $optionsFilter)
        Form {
            Picker("", selection: $selectedOption) {
                ForEach(options, id: \.value) { option in
                    HStack {
                        AsyncImage(url: URL(string: option.image ?? ""))
                        Text(option.name ?? "")
                    }.tag(option.value ?? "")
                    
                }
            }.pickerStyle(.inline)
                .onChange(of: selectedOption) { newValue in
                    isValid(true)
                    returnValue(newValue)
                }
        }
        
    }
}
