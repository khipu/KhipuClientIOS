//
//  HintLabel.swift
//  khenshinClientIos
//
//  Created by Emilio Davis on 18-05-24.
//

import SwiftUI

@available(iOS 13.0, *)
struct HintLabel: View {
    var text: String?
    @ObservedObject var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            Spacer()
            Text(text ?? "")
                .font(.caption)
                .foregroundColor(themeManager.selectedTheme.onSurface)
            }
    }
}
