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
    var bundle = KhipuClientBundleHelper.podBundle
    var colorScheme: ColorScheme = .light
    
    
    
    //topBarContainer
    var topBarContainer: Color {
        if colorScheme == .dark {
            return localColors.darkTopBarContainer ?? Color("topBarContainer", bundle: bundle)
        }
        return localColors.lightOnBackground ?? Color("topBarContainer", bundle: bundle)
    }
    
    //onBackground
    var onBackground: Color {
        if colorScheme == .dark {
            return localColors.darkOnBackground ?? Color("onBackground", bundle: bundle)
        }
        return localColors.lightOnBackground ?? Color("onBackground", bundle: bundle)
    }
    
    //onPrimary
    var onPrimary: Color {
        if colorScheme == .dark {
            return localColors.darkOnPrimary ?? Color("onPrimary", bundle: bundle)
        }
        return localColors.lightOnBackground ?? Color("onPrimary", bundle: bundle)
    }
    
    //onTopBarContainer
    var onTopBarContainer: Color {
        if colorScheme == .dark {
            return localColors.darkOnTopBarContainer ?? Color("onTopBarContainer", bundle: bundle)
        }
        return localColors.lightOnBackground ?? Color("onTopBarContainer", bundle: bundle)
    }
    
    //primary
    var primary: Color {
        if colorScheme == .dark {
            return localColors.darkPrimary ?? Color("primary", bundle: bundle)
        }
        return localColors.lightOnBackground ?? Color("primary", bundle: bundle)
    }
    
    //background
    var background: Color {
        if colorScheme == .dark {
            return localColors.darkBackground ?? Color("background", bundle: bundle)
        }
        return localColors.lightOnBackground ?? Color("background", bundle: bundle)
    }
    
    //disabled
    var disabled: Color {
        return Color("disabled", bundle: bundle)
    }

    //onDisabled
    var onDisabled: Color {
        return Color("onDisabled", bundle: bundle)
    }

    //onSecondaryContainer
    var onSecondaryContainer: Color {
        return Color("onSecondaryContainer", bundle: bundle)
    }
    //onSuccess
    var onSuccess: Color {
        return Color("onSuccess", bundle: bundle)
    }
    
    //onSurface
    var onSurface: Color {
        return Color("onSurface", bundle: bundle)
    }
    
    //onSurfaceVariant
    var onSurfaceVariant: Color {
        return Color("onSurfaceVariant", bundle: bundle)
    }
    
    //onTertiary
    var onTertiary: Color {
        return Color("onTertiary", bundle: bundle)
    }
    
    //onTertiaryContainer
    var onTertiaryContainer: Color {
        return Color("onTertiaryContainer", bundle: bundle)
    }
    
    //outline
    var outline: Color {
        return Color("outline", bundle: bundle)
    }
    
    //outlineVariant
    var outlineVariant: Color {
        return Color("outlineVariant", bundle: bundle)
    }
    
    //placeholder
    var placeholder: Color {
        return Color("placeholder", bundle: bundle)
    }
    
    //secondary
    var secondary: Color {
        return Color("secondary", bundle: bundle)
    }
    
    //secondaryContainer
    var secondaryContainer: Color {
        return Color("secondaryContainer", bundle: bundle)
    }
    
    //sucess
    var success: Color {
        return Color("success", bundle: bundle)
    }
    
    //surface
    var surface: Color {
        return Color("surface", bundle: bundle)
    }
    
    //tertiary
    var tertiary: Color {
        return Color("tertiary", bundle: bundle)
    }
    
    //tertiaryContainer
    var tertiaryContainer: Color {
        return Color("tertiaryContainer", bundle: bundle)
    }

    //onSecondary
    var onSecondary: Color {
        return Color("onSecondary", bundle: bundle)
    }
    
    //info
    var info: Color {
        return Color("info", bundle: bundle)
    }
    
    //error
    var error: Color {
        return Color("error", bundle: bundle)
    }
    
    //warning
    var warning: Color {
        return Color("warning", bundle: bundle)
    }
    
}
