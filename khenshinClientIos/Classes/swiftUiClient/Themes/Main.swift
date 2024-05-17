//
//  Main.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 16-05-24.
//

import SwiftUI
/**
 Main Theme
 */
@available(iOS 13.0, *)
struct Main: ThemeProtocol {
    var backgroundButtonDisabled: Color { return Color("backgroundButtonDisabled") }
    var backgroundButtonEnabled: Color { return Color("backgroundButtonEnabled") }
    var boxBorder: Color { return Color("boxBorder") }
    var closeButton: Color { return Color("closeButton") }
    var foregroundButtonActive: Color { return Color("foregroundButtonActive") }
    var foregroundButtonInactive: Color { return Color("foregroundButtonInactive") }
}
