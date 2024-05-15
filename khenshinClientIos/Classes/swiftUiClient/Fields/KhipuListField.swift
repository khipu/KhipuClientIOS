//
//  TextField.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 09-05-24.
//

import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct KhipuListField: View {
    let formItem: FormItem
    let isValid: (Bool) -> Void
    let returnValue: (String) -> Void
    let submitFunction: () -> Void
    
    @State private var selectedOption: ListOption?
    
    var body: some View {
        VStack(alignment: .leading, spacing: Dimensions.small) {
            ForEach(formItem.options ?? [], id: \.value) { option in
                Button(action: {
                    selectedOption = option
                    isValid(true)
                    returnValue(option.value ?? "")
                    submitFunction()
                }) {
                    VStack(alignment: .leading, spacing: Dimensions.small) {
                        Text(option.name ?? "")
                            //.font(.bodyMedium)
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            //.foregroundColor(MaterialTheme.colorScheme.onSurface)
                        
                        if let dataTable = option.dataTable, !dataTable.rows.isEmpty {
                            KhipuDataTable(dataTable: dataTable)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
                }
            }
        }
    }
}

struct Dimensions {
    static let small: CGFloat = 8
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
    static let extraLarge: CGFloat = 48
    static let veryLarge: CGFloat = 64
}

