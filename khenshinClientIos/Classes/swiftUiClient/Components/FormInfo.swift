//
//  FormInfo.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 08-05-24.
//

import SwiftUI

@available(iOS 15.0, *)
struct FormInfo: View {
    let text: String
    @StateObject private var khenshinViewModel: KhenshinViewModel = KhenshinViewModel()
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
                .frame(width: 10)
            Image(systemName: "info")
                //.foregroundColor(Color(uiColor: .secondaryColor))
                .frame(width: 20, height: 20)
            Text(text)
                .font(.title2)
                //.foregroundColor(Color(uiColor: .secondaryColor))
                .padding(10)
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                //.stroke(Color(uiColor: .secondaryColor), lineWidth: 1)
                //.background(Color(uiColor: .onSecondary))
        )
        .padding(.horizontal)
    }
}
