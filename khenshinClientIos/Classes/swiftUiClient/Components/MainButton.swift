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
                .font(.body)
        }
        .disabled(!enabled)
        .frame(maxWidth: .infinity, minHeight: 56)
    }
}
