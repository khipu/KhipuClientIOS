//
//  FormPill.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 08-05-24.
//

import SwiftUI

@available(iOS 13.0, *)
struct FormPill: View {
    private var text: String
    
    init(text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text).overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.blue, lineWidth: 1.5))
    }
}

@available(iOS 13.0, *)
struct FormPill_Previews: PreviewProvider {
    static var previews: some View {
        FormPill(text: "Nombre banco")
    }
}
