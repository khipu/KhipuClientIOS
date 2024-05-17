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
    var backgroundButtonDisabled: Color { return Color("backgroundButtonDisabled", bundle: Bundle.module) }
    var backgroundButtonEnabled: Color { return Color("backgroundButtonEnabled", bundle: Bundle(path: "khenshinClientIos/Assets/Resources/KhipuColors.xcassets")) }
    var boxBorder: Color { return Color("boxBorder", bundle: Bundle(path: "khenshinClientIos/Assets/Resources/KhipuColors.xcassets")) }
    var closeButton: Color { return Color("closeButton", bundle: Bundle(path: "khenshinClientIos/Assets/Resources/KhipuColors.xcassets")) }
    var foregroundButtonActive: Color { return Color("foregroundButtonActive", bundle: Bundle(path: "khenshinClientIos/Assets/Resources/KhipuColors.xcassets")) }
    var foregroundButtonInactive: Color { return Color("foregroundButtonInactive", bundle: Bundle(path: "khenshinClientIos/Assets/Resources/KhipuColors.xcassets")) }
}
