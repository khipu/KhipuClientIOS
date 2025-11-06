import Foundation
import SwiftUI

@available(iOS 13.0, *)
struct Colors {
    var localColors: LocalColors = LocalColors()
    var colorScheme: ColorScheme = .light

    // MARK: - Default Colors

    // topBarContainer
    private let lightTopBarContainerDefault = Color(hexString: "#EDDBFC")!
    private let darkTopBarContainerDefault = Color(hexString: "#432064")!

    // onBackground
    private let lightOnBackgroundDefault = Color(hexString: "#272930")!
    private let darkOnBackgroundDefault = Color(hexString: "#E7E0E5")!

    // onPrimary
    private let lightOnPrimaryDefault = Color(hexString: "#FFFFFF")!
    private let darkOnPrimaryDefault = Color(hexString: "#4C0676")!

    // onTopBarContainer
    private let lightOnTopBarContainerDefault = Color(hexString: "#432064")!
    private let darkOnTopBarContainerDefault = Color(hexString: "#EDDBFC")!

    // primary
    private let lightPrimaryDefault = Color(hexString: "#8347AD")!
    private let darkPrimaryDefault = Color(hexString: "#E3B5FF")!

    // background
    private let lightBackgroundDefault = Color(hexString: "#FFFFFF")!
    private let darkBackgroundDefault = Color(hexString: "#1D1B1E")!

    // disabled
    private let lightDisabledDefault = Color(hexString: "#F2F1F4")!
    private let darkDisabledDefault = Color(hexString: "#353336")!

    // onDisabled
    private let onDisabledDefault = Color(hexString: "#9797A5")!

    // onSecondaryContainer
    private let lightOnSecondaryContainerDefault = Color(hexString: "#001B3D")!
    private let darkOnSecondaryContainerDefault = Color(hexString: "#D6E3FF")!

    // onSuccess
    private let lightOnSuccessDefault = Color(hexString: "#FFFFFF")!
    private let darkOnSuccessDefault = Color(hexString: "#003A04")!

    // onSurface
    private let lightOnSurfaceDefault = Color(hexString: "#272930")!
    private let darkOnSurfaceDefault = Color(hexString: "#E7E0E5")!

    // onSurfaceVariant
    private let lightOnSurfaceVariantDefault = Color(hexString: "#81848F")!
    private let darkOnSurfaceVariantDefault = Color(hexString: "#CDC3CE")!

    // onTertiary
    private let lightOnTertiaryDefault = Color(hexString: "#4D2D00")!
    private let darkOnTertiaryDefault = Color(hexString: "#4B2800")!

    // onTertiaryContainer
    private let lightOnTertiaryContainerDefault = Color(hexString: "#663C00")!
    private let darkOnTertiaryContainerDefault = Color(hexString: "#FFDCC0")!

    // outline
    private let lightOutlineDefault = Color(hexString: "#DDDEE0")!
    private let darkOutlineDefault = Color(hexString: "#968E98")!

    // outlineVariant
    private let lightOutlineVariantDefault = Color(hexString: "#EEEFF0")!
    private let darkOutlineVariantDefault = Color(hexString: "#4B454D")!

    // placeholder
    private let lightPlaceholderDefault = Color(hexString: "#9DA1AC")!
    private let darkPlaceholderDefault = Color(hexString: "#81848F")!

    // secondary
    private let lightSecondaryDefault = Color(hexString: "#005EB5")!
    private let darkSecondaryDefault = Color(hexString: "#ADC6FF")!

    // secondaryContainer
    private let lightSecondaryContainerDefault = Color(hexString: "#005EB5")!
    private let darkSecondaryContainerDefault = Color(hexString: "#ADC6FF")!

    // success
    private let lightSuccessDefault = Color(hexString: "#0D6E13")!
    private let darkSuccessDefault = Color(hexString: "#2CA24D")!

    // surface
    private let lightSurfaceDefault = Color(hexString: "#FFFFFF")!
    private let darkSurfaceDefault = Color(hexString: "#1D1B1E")!

    // tertiary
    private let lightTertiaryDefault = Color(hexString: "#EAC54F")!
    private let darkTertiaryDefault = Color(hexString: "#FFB875")!

    // tertiaryContainer
    private let lightTertiaryContainerDefault = Color(hexString: "#ED6C02")!
    private let darkTertiaryContainerDefault = Color(hexString: "#6B3B00")!

    // onSecondary
    private let lightOnSecondaryDefault = Color(hexString: "#FFFFFF")!
    private let darkOnSecondaryDefault = Color(hexString: "#003062")!

    // info
    private let lightInfoDefault = Color(hexString: "#005EB5")!
    private let darkInfoDefault = Color(hexString: "#ADC6FF")!

    // error
    private let lightErrorDefault = Color(hexString: "#BA1A1A")!
    private let darkErrorDefault = Color(hexString: "#FFB4AB")!

    // warning
    private let lightWarningDefault = Color(hexString: "#ED6C02")!
    private let darkWarningDefault = Color(hexString: "#FFB875")!

    // operationIdText
    private let lightOperationIdTextDefault = Color(hexString: "#555E68")!
    private let darkOperationIdTextDefault = Color(hexString: "#B2B2A6")!

    // scaffoldBackground
    private let lightScaffoldBackgroundDefault = Color(hexString: "#F5F5F5")!
    private let darkScaffoldBackgroundDefault = Color(hexString: "#121212")!

    // MARK: - Public Color Properties

    var topBarContainer: Color {
        if colorScheme == .dark {
            return localColors.darkTopBarContainer ?? darkTopBarContainerDefault
        }
        return localColors.lightTopBarContainer ?? lightTopBarContainerDefault
    }

    var onBackground: Color {
        if colorScheme == .dark {
            return localColors.darkOnBackground ?? darkOnBackgroundDefault
        }
        return localColors.lightOnBackground ?? lightOnBackgroundDefault
    }

    var onPrimary: Color {
        if colorScheme == .dark {
            return localColors.darkOnPrimary ?? darkOnPrimaryDefault
        }
        return localColors.lightOnPrimary ?? lightOnPrimaryDefault
    }

    var onTopBarContainer: Color {
        if colorScheme == .dark {
            return localColors.darkOnTopBarContainer ?? darkOnTopBarContainerDefault
        }
        return localColors.lightOnTopBarContainer ?? lightOnTopBarContainerDefault
    }

    var primary: Color {
        if colorScheme == .dark {
            return localColors.darkPrimary ?? darkPrimaryDefault
        }
        return localColors.lightPrimary ?? lightPrimaryDefault
    }

    var background: Color {
        if colorScheme == .dark {
            return localColors.darkBackground ?? darkBackgroundDefault
        }
        return localColors.lightBackground ?? lightBackgroundDefault
    }

    var disabled: Color {
        if colorScheme == .dark {
            return darkDisabledDefault
        }
        return lightDisabledDefault
    }

    var onDisabled: Color {
        return onDisabledDefault
    }

    var onSecondaryContainer: Color {
        if colorScheme == .dark {
            return darkOnSecondaryContainerDefault
        }
        return lightOnSecondaryContainerDefault
    }

    var onSuccess: Color {
        if colorScheme == .dark {
            return darkOnSuccessDefault
        }
        return lightOnSuccessDefault
    }

    var onSurface: Color {
        if colorScheme == .dark {
            return darkOnSurfaceDefault
        }
        return lightOnSurfaceDefault
    }

    var onSurfaceVariant: Color {
        if colorScheme == .dark {
            return darkOnSurfaceVariantDefault
        }
        return lightOnSurfaceVariantDefault
    }

    var onTertiary: Color {
        if colorScheme == .dark {
            return darkOnTertiaryDefault
        }
        return lightOnTertiaryDefault
    }

    var onTertiaryContainer: Color {
        if colorScheme == .dark {
            return darkOnTertiaryContainerDefault
        }
        return lightOnTertiaryContainerDefault
    }

    var outline: Color {
        if colorScheme == .dark {
            return darkOutlineDefault
        }
        return lightOutlineDefault
    }

    var outlineVariant: Color {
        if colorScheme == .dark {
            return darkOutlineVariantDefault
        }
        return lightOutlineVariantDefault
    }

    var placeholder: Color {
        if colorScheme == .dark {
            return darkPlaceholderDefault
        }
        return lightPlaceholderDefault
    }

    var secondary: Color {
        if colorScheme == .dark {
            return darkSecondaryDefault
        }
        return lightSecondaryDefault
    }

    var secondaryContainer: Color {
        if colorScheme == .dark {
            return darkSecondaryContainerDefault
        }
        return lightSecondaryContainerDefault
    }

    var success: Color {
        if colorScheme == .dark {
            return darkSuccessDefault
        }
        return lightSuccessDefault
    }

    var surface: Color {
        if colorScheme == .dark {
            return darkSurfaceDefault
        }
        return lightSurfaceDefault
    }

    var tertiary: Color {
        if colorScheme == .dark {
            return darkTertiaryDefault
        }
        return lightTertiaryDefault
    }

    var tertiaryContainer: Color {
        if colorScheme == .dark {
            return darkTertiaryContainerDefault
        }
        return lightTertiaryContainerDefault
    }

    var onSecondary: Color {
        if colorScheme == .dark {
            return darkOnSecondaryDefault
        }
        return lightOnSecondaryDefault
    }

    var info: Color {
        if colorScheme == .dark {
            return darkInfoDefault
        }
        return lightInfoDefault
    }

    var error: Color {
        if colorScheme == .dark {
            return darkErrorDefault
        }
        return lightErrorDefault
    }

    var warning: Color {
        if colorScheme == .dark {
            return darkWarningDefault
        }
        return lightWarningDefault
    }

    var operationIdText: Color {
        if colorScheme == .dark {
            return darkOperationIdTextDefault
        }
        return lightOperationIdTextDefault
    }

    var scaffoldBackground: Color {
        if colorScheme == .dark {
            return darkScaffoldBackgroundDefault
        }
        return lightScaffoldBackgroundDefault
    }
}
