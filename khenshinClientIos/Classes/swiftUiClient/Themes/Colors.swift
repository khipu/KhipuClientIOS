//
//  Colors.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 20-05-24.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
struct Colors {
    var localColors: LocalColors = LocalColors()
    var bundle = Bundle(identifier: "org.cocoapods.khenshinClientIos")
    var colorScheme: ColorScheme = .light
    
    var primary: Color {
        if(colorScheme == .dark) {
            return localColors.darkPrimary ?? Color("primary", bundle: bundle)
        }
        return localColors.lightPrimary ?? Color("primary", bundle: bundle)
    }
    
    var onPrimary: Color {
        if(colorScheme == .dark) {
            return localColors.darkOnPrimary ?? Color("onPrimary", bundle: bundle)
        }
        return localColors.lightOnPrimary ?? Color("onPrimary", bundle: bundle)
    }
    
    var primaryContainer: Color {
        return Color("primaryContainer", bundle: bundle)
    }
    
    var onPrimaryContainer: Color {
        return Color("onPrimaryContainer", bundle: bundle)
    }
    
    var secondary: Color {
        return Color("secondary", bundle: bundle)
    }
    
    var onSecondary: Color {
        return Color("onSecondary", bundle: bundle)
    }
    
    var secondaryContainer: Color {
        return Color("secondaryContainer", bundle: bundle)
    }
    
    var onSecondaryContainer: Color {
        return Color("onSecondaryContainer", bundle: bundle)
    }
    
    var tertiary: Color {
        return Color("tertiary", bundle: bundle)
    }
    
    var onTertiary: Color {
        return Color("onTertiary", bundle: bundle)
    }
    
    var tertiaryContainer: Color {
        return Color("tertiaryContainer", bundle: bundle)
    }
    
    var onTertiaryContainer: Color {
        return Color("onTertiaryContainer", bundle: bundle)
    }
    
    var error: Color {
        return Color("error", bundle: bundle)
    }
    
    var errorContainer: Color {
        return Color("errorContainer", bundle: bundle)
    }
    
    var onError: Color {
        return Color("onError", bundle: bundle)
    }
    
    var onErrorContainer: Color {
        return Color("onErrorContainer", bundle: bundle)
    }
    
    var background: Color {
        if(colorScheme == .dark) {
            return localColors.darkBackground ?? Color("background", bundle: bundle)
        }
        return localColors.lightBackground ?? Color("background", bundle: bundle)
    }
    
    var onBackground: Color {
        if(colorScheme == .dark) {
            return localColors.darkOnBackground ?? Color("onBackground", bundle: bundle)
        }
        return localColors.lightOnBackground ?? Color("onBackground", bundle: bundle)
    }
    
    var surface: Color {
        if(colorScheme == .dark) {
            return localColors.darkBackground ?? Color("surface", bundle: bundle)
        }
        return localColors.lightBackground ?? Color("surface", bundle: bundle)
    }
    
    var onSurface: Color {
        if(colorScheme == .dark) {
            return localColors.darkOnBackground ?? Color("onSurface", bundle: bundle)
        }
        return localColors.lightOnBackground ?? Color("onSurface", bundle: bundle)
    }
    
    var surfaceVariant: Color {
        return Color("surfaceVariant", bundle: bundle)
    }
    
    var onSurfaceVariant: Color {
        return Color("onSurfaceVariant", bundle: bundle)
    }
    
    var outline: Color {
        return Color("outline", bundle: bundle)
    }
    
    var inverseOnSurface: Color {
        return Color("inverseOnSurface", bundle: bundle)
    }
    
    var inverseSurface: Color {
        return Color("inverseSurface", bundle: bundle)
    }
    
    var inversePrimary: Color {
        return Color("inversePrimary", bundle: bundle)
    }
    
    var surfaceTint: Color {
        return Color("surfaceTint", bundle: bundle)
    }
    
    var outlineVariant: Color {
        return Color("outlineVariant", bundle: bundle)
    }
    
    var scrim: Color {
        return Color("scrim", bundle: bundle)
    }
    
    var topBarContainer: Color {
        if(colorScheme == .dark) {
            return localColors.darkTopBarContainer ?? Color("topBarContainer", bundle: bundle)
        }
        return localColors.lightTopBarContainer ?? Color("topBarContainer", bundle: bundle)
    }
    
    var onTopBarContainer: Color {
        if(colorScheme == .dark) {
            return localColors.darkOnTopBarContainer ?? Color("onTopBarContainer", bundle: bundle)
        }
        return localColors.lightOnTopBarContainer ?? Color("onTopBarContainer", bundle: bundle)
    }
    
    var success: Color {
        return Color("success", bundle: bundle)
    }
    
    var onSuccess: Color {
        return Color("onSuccess", bundle: bundle)
    }
    
    var successContainer: Color {
        return Color("successContainer", bundle: bundle)
    }
    
    var onSuccessContainer: Color {
        return Color("onSuccessContainer", bundle: bundle)
    }
}
