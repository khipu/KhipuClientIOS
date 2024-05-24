//
//  iOSCheckboxToggleStyle.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 23-05-24.
//

import SwiftUI

@available(iOS 13.0, *)
struct iOSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                configuration.label
            }
        })
    }
}
