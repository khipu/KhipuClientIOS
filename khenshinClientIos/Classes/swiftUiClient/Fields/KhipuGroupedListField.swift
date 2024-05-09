//
//  TextField.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 09-05-24.
//

import SwiftUI
import KhenshinProtocol

@available(iOS 13.0, *)
struct KhipuGroupedListField: View {
    var formItem: FormItem
    var hasNextField: Bool
    var isValid: (Bool) -> Void
    var returnValue: (String) -> Void
    @State var passwordVisible: Bool = false
    @State var textFieldValue: String = ""
    
    var body: some View {
        Text(formItem.label ?? "")
        TextField(formItem.label ?? "", text: $textFieldValue)
    }
}
