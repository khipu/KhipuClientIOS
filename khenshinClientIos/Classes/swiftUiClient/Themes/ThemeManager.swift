//
//  ThemeManager.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 16-05-24.
//

import SwiftUI
/**
 Theme Manager
 */
@available(iOS 13.0, *)
class ThemeManager: ObservableObject {
    
    @Published var selectedTheme: ThemeProtocol = KhipuTheme()
    
    func setTheme(_ theme: ThemeProtocol) {
        selectedTheme = theme
    }

}
