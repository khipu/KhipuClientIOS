//
//  ThemeProtocol.swift
//
//
//  Created by Mauricio Castillo on 16-05-24.
//

import SwiftUI
/**
 Protocol for themes
 */
@available(iOS 13.0, *)
protocol ThemeProtocol {
    var backgroundButtonDisabled: Color { get }
    var backgroundButtonEnabled: Color { get }
    var boxBorder: Color { get }
    var closeButton: Color { get }
    var foregroundButtonActive: Color { get }
    var foregroundButtonInactive: Color { get }
}
