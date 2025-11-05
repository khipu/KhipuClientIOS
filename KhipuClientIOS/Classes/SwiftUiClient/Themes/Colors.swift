import Foundation
import SwiftUI

@available(iOS 13.0, *)
struct Colors {
    var localColors: LocalColors = LocalColors()
    var bundle = KhipuClientBundleHelper.podBundle
    var colorScheme: ColorScheme = .light
    
    var topBarContainer: Color {
        if colorScheme == .dark {
            return localColors.darkTopBarContainer ?? Color("topBarContainer", bundle: bundle)
        }
        return localColors.lightTopBarContainer ?? Color("topBarContainer", bundle: bundle)
    }
    
    var onBackground: Color {
        if colorScheme == .dark {
            return localColors.darkOnBackground ?? Color("onBackground", bundle: bundle)
        }
        return localColors.lightOnBackground ?? Color("onBackground", bundle: bundle)
    }
    
    var onPrimary: Color {
        if colorScheme == .dark {
            return localColors.darkOnPrimary ?? Color("onPrimary", bundle: bundle)
        }
        return localColors.lightOnPrimary ?? Color("onPrimary", bundle: bundle)
    }
    
    var onTopBarContainer: Color {
        if colorScheme == .dark {
            return localColors.darkOnTopBarContainer ?? Color("onTopBarContainer", bundle: bundle)
        }
        return localColors.lightOnTopBarContainer ?? Color("onTopBarContainer", bundle: bundle)
    }
    
    var primary: Color {
        if colorScheme == .dark {
            return localColors.darkPrimary ?? Color("primary", bundle: bundle)
        }
        return localColors.lightPrimary ?? Color("primary", bundle: bundle)
    }
    
    var background: Color {
        if colorScheme == .dark {
            return localColors.darkBackground ?? Color("background", bundle: bundle)
        }
        return localColors.lightBackground ?? Color("background", bundle: bundle)
    }
    
    var disabled: Color {
        return Color("disabled", bundle: bundle)
    }
    
    var onDisabled: Color {
        return Color("onDisabled", bundle: bundle)
    }
    
    var onSecondaryContainer: Color {
        return Color("onSecondaryContainer", bundle: bundle)
    }
    
    var onSuccess: Color {
        return Color("onSuccess", bundle: bundle)
    }
    
    var onSurface: Color {
        return Color("onSurface", bundle: bundle)
    }
    
    var onSurfaceVariant: Color {
        return Color("onSurfaceVariant", bundle: bundle)
    }
    
    var onTertiary: Color {
        return Color("onTertiary", bundle: bundle)
    }
    
    var onTertiaryContainer: Color {
        return Color("onTertiaryContainer", bundle: bundle)
    }
    
    var outline: Color {
        return Color("outline", bundle: bundle)
    }
    
    var outlineVariant: Color {
        return Color("outlineVariant", bundle: bundle)
    }
    
    var placeholder: Color {
        return Color("placeholder", bundle: bundle)
    }
    
    var secondary: Color {
        return Color("secondary", bundle: bundle)
    }
    
    var secondaryContainer: Color {
        return Color("secondaryContainer", bundle: bundle)
    }
    
    var success: Color {
        return Color("success", bundle: bundle)
    }
    
    var surface: Color {
        return Color("surface", bundle: bundle)
    }
    
    var tertiary: Color {
        return Color("tertiary", bundle: bundle)
    }
    
    var tertiaryContainer: Color {
        return Color("tertiaryContainer", bundle: bundle)
    }
    
    var onSecondary: Color {
        return Color("onSecondary", bundle: bundle)
    }
    
    var info: Color {
        return Color("info", bundle: bundle)
    }
    
    var error: Color {
        return Color("error", bundle: bundle)
    }
    
    var warning: Color {
        return Color("warning", bundle: bundle)
    }
    
    var operationIdText: Color {
        return Color("operationIdText", bundle: bundle)
    }
    
}
