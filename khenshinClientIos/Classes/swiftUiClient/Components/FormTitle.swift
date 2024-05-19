//
//  FormTitle.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 08-05-24.
//

import SwiftUI

@available(iOS 13.0, *)
struct FormTitle: View {
    var text: String
    @ObservedObject var themeManager: ThemeManager
    
    var body: some View {
        Text(text)
            .font(.title)
            .foregroundColor(themeManager.selectedTheme.onSurface)
            .multilineTextAlignment(.center)
            .padding()
    }
}

@available(iOS 13.0, *)
struct FormTitle_Previews: PreviewProvider {
    static var previews: some View {
        FormTitle(text: "Título", themeManager: ThemeManager())
    }
}
