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
    @EnvironmentObject private var themeManager: ThemeManager
    let foregroundColor: Color
    let backgroundColor: Color
    
    var body: some View {
        Button(action: onClick) {
            Text(text)
                .foregroundColor(enabled ? foregroundColor : .secondary.opacity(0.3))
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(enabled ? backgroundColor : .gray.opacity(0.5))
                .cornerRadius(Dimens.extraSmall)
        }
        .disabled(!enabled)
    }
}
