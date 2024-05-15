//
//  MainButton.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 09-05-24.
//

import SwiftUI

@available(iOS 13.0, *)
struct MainButton: View {
    let text: String
    let enabled: Bool
    let onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            Text(text)
                .fontWeight(.bold)
                .foregroundColor(enabled ? Color.white : Color.gray)
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(enabled ? Color(red: 60/255, green: 180/255, blue: 229/255) : Color.gray.opacity(0.5))
                .cornerRadius(10)
        }
        .disabled(!enabled)
        .padding(.horizontal, 20)
        
        
    }
}
