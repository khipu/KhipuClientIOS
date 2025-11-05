import SwiftUI

struct Dimens {
    static let none: CGFloat = 0
    static let small: CGFloat = 2
    static let verySmall: CGFloat = 4
    static let moderatelySmall: CGFloat = 6
    static let extraSmall: CGFloat = 8
    static let medium: CGFloat = 10
    static let veryMedium: CGFloat = 12
    static let moderatelyMedium: CGFloat = 15
    static let extraMedium: CGFloat = 16
    static let large: CGFloat = 20
    static let moderatelyLarge: CGFloat = 24
    static let quiteLarge: CGFloat = 32
    static let veryLarge: CGFloat = 36
    static let slightlyLarger: CGFloat = 40
    static let almostLarge: CGFloat = 45
    static let larger: CGFloat = 48
    static let extraLarge: CGFloat = 54
    static let substantiallyLarge: CGFloat = 65
    static let muchLarger: CGFloat = 80
    static let extremelyLarge: CGFloat = 90
    static let huge: CGFloat = 100
    static let veryHuge: CGFloat = 120
    static let extraHuge: CGFloat = 150
    static let massive: CGFloat = 180
    static let gigantic: CGFloat = 200
    static let colossal: CGFloat = 300


    struct Spacing {
        static let small = Dimens.small
        static let verySmall = Dimens.verySmall
        static let moderatelySmall = Dimens.moderatelySmall
        static let extraSmall = Dimens.extraSmall
        static let medium = Dimens.medium
        static let veryMedium = Dimens.veryMedium
        static let extraMedium = Dimens.extraMedium
        static let large = Dimens.large
        static let headerContent: CGFloat = 16
    }

    struct Padding {
        static let verySmall = Dimens.verySmall
        static let moderatelySmall = Dimens.moderatelySmall
        static let extraSmall = Dimens.extraSmall
        static let medium = Dimens.medium
        static let veryMedium = Dimens.veryMedium
        static let extraMedium = Dimens.extraMedium
        static let large = Dimens.large
        static let moderatelyLarge = Dimens.moderatelyLarge
        static let quiteLarge = Dimens.quiteLarge
        static let veryLarge = Dimens.veryLarge
        static let slightlyLarger = Dimens.slightlyLarger
        static let larger = Dimens.larger
        static let extraLarge = Dimens.extraLarge
        static let massive = Dimens.massive
    }

    struct CornerRadius {
        static let verySmall = Dimens.verySmall
        static let moderatelySmall = Dimens.moderatelySmall
        static let extraSmall = Dimens.extraSmall
        static let medium = Dimens.medium
        static let large = Dimens.large
        static let formContainer = Dimens.large
    }

    struct Frame {
        static let verySmall = Dimens.extraSmall
        static let moderatelyMedium = Dimens.moderatelyMedium
        static let extraMedium = Dimens.extraMedium
        static let medium = Dimens.large
        static let icon: CGFloat = 24 // Tamaño estándar de íconos
        static let large = Dimens.moderatelyLarge
        static let quiteLarge = Dimens.quiteLarge
        static let slightlyLarger = Dimens.slightlyLarger
        static let almostLarge = Dimens.almostLarge
        static let larger = Dimens.larger
        static let extraLarge = Dimens.extraLarge
        static let materialTextField: CGFloat = 56 // Altura del Material TextField
        static let substantiallyLarge = Dimens.substantiallyLarge
        static let muchLarger = Dimens.muchLarger
        static let extremelyLarge = Dimens.extremelyLarge
        static let veryHuge = Dimens.veryHuge
        static let gigantic = Dimens.gigantic
        static let colossal = Dimens.colossal
    }

    struct Image {
        static let veryMedium = Dimens.veryMedium
        static let small = Dimens.large
        static let bankLogo: CGFloat = 35
        static let emptyStateIcon: CGFloat = 32
        static let slightlyLarger = Dimens.slightlyLarger
        static let larger = Dimens.larger
        static let merchantLogo: CGFloat = 70
        static let huge = Dimens.huge
        static let extraHuge = Dimens.extraHuge
        static let gigantic = Dimens.gigantic
    }

    struct LineHeight {
        static let tabIndicator: CGFloat = 2
    }
}
