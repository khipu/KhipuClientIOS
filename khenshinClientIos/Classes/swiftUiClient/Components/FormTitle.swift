//
//  FormTitle.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 08-05-24.
//

import SwiftUI

@available(iOS 13.0, *)
struct FormTitle: View {
    private var text: String
    
    init(text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.title)
            .foregroundColor(.primary)
            .multilineTextAlignment(.center)
            .padding()
    }
}

@available(iOS 13.0, *)
struct FormTitle_Previews: PreviewProvider {
    static var previews: some View {
        FormTitle(text: "Título")
    }
}
