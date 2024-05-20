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
    
    func setColorSchemeAndCustomColors(colorScheme: ColorScheme, colors: KhipuColors?)
    
    var colors: Colors { get }
    
    var dimens: Dimens { get }
    
    //var primary: Color { get }
    //
    //var onPrimary: Color { get }
    //
    //var primaryContainer: Color { get }
    //
    //var onPrimaryContainer: Color { get }
    //
    //var secondary: Color { get }
    //
    //var onSecondary: Color { get }
    //
    //var secondaryContainer: Color { get }
    //
    //var onSecondaryContainer: Color { get }
    //
    //var tertiary: Color { get }
    
    //var onTertiary: Color { get }
    //
    //var tertiaryContainer: Color { get }
    //
    //var onTertiaryContainer: Color { get }
    //
    //var error: Color { get }
    //
    //var errorContainer: Color { get }
    //
    //var onError: Color { get }
    //
    //var onErrorContainer: Color { get }
    //
    //var background: Color { get }
    //
    //var onBackground: Color { get }
    //
    //var surface: Color { get }
    //
    //var onSurface: Color { get }
    //
    //var surfaceVariant: Color { get }
    //
    //var onSurfaceVariant: Color { get }
    //
    //var outline: Color { get }
    //
    //var inverseOnSurface: Color { get }
    //
    //var inverseSurface: Color { get }
    //
    //var inversePrimary: Color { get }
    //
    //var surfaceTint: Color { get }
    //
    //var outlineVariant: Color { get }
    //
    //var scrim: Color { get }
    //
    //var topBarContainer: Color { get }
    //
    //var onTopBarContainer: Color { get }
    //
    //var success: Color { get }
    //
    //var onSuccess: Color { get }
    //
    //var successContainer: Color { get }
    //
    //var onSuccessContainer: Color { get }
}
