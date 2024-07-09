import SwiftUI

struct Dimens {
    // Definición de valores comunes
    static let none: CGFloat = 0
    static let small: CGFloat = 2
    static let verySmall: CGFloat = 4
    static let moderatelySmall: CGFloat = 6
    static let extraSmall: CGFloat = 8
    static let medium: CGFloat = 10
    static let veryMedium: CGFloat = 12
    static let extraMedium: CGFloat = 16
    static let large: CGFloat = 20
    static let moderatelyLarge: CGFloat = 24
    static let quiteLarge: CGFloat = 32
    static let veryLarge: CGFloat = 36
    static let slightlyLarger: CGFloat = 40
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
        static let small = Dimens.small // 2
        static let verySmall = Dimens.verySmall // 4
        static let moderatelySmall = Dimens.moderatelySmall // 6
        static let extraSmall = Dimens.extraSmall // 8
        static let medium = Dimens.medium // 10
        static let veryMedium = Dimens.veryMedium // 12
        static let extraMedium = Dimens.extraMedium // 16
        static let large = Dimens.large // 20
    }

    struct Padding {
        static let verySmall = Dimens.verySmall // 4
        static let moderatelySmall = Dimens.moderatelySmall // 6
        static let extraSmall = Dimens.extraSmall // 8
        static let medium = Dimens.medium // 10
        static let veryMedium = Dimens.veryMedium // 12
        static let extraMedium = Dimens.extraMedium // 16
        static let large = Dimens.large // 20
        static let moderatelyLarge = Dimens.moderatelyLarge // 24
        static let quiteLarge = Dimens.quiteLarge // 32
        static let veryLarge = Dimens.veryLarge // 36
        static let slightlyLarger = Dimens.slightlyLarger // 40
        static let larger = Dimens.larger // 48
        static let extraLarge = Dimens.extraLarge // 54
        static let massive = Dimens.massive // 180
    }

    struct CornerRadius {
        static let verySmall = Dimens.verySmall // 4
        static let moderatelySmall = Dimens.moderatelySmall // 6
        static let extraSmall = Dimens.extraSmall // 8
        static let medium = Dimens.medium // 10
        static let large = Dimens.large // 20
    }

    struct Frame {
        static let verySmall = Dimens.extraSmall // 8
        static let medium = Dimens.large // 20
        static let large = Dimens.moderatelyLarge // 24
        static let quiteLarge = Dimens.quiteLarge // 32
        static let larger = Dimens.larger // 48
        static let extraLarge = Dimens.extraLarge // 54
        static let substantiallyLarge = Dimens.substantiallyLarge // 65
        static let muchLarger = Dimens.muchLarger // 80
        static let extremelyLarge = Dimens.extremelyLarge // 90
        static let slightlyLarger = Dimens.slightlyLarger // 40
        static let gigantic = Dimens.gigantic // 200
        static let colossal = Dimens.colossal // 300
    }

    struct Image {
        static let small = Dimens.large // 20
        static let slightlyLarger = Dimens.slightlyLarger // 40
        static let larger = Dimens.larger // 48
        static let huge = Dimens.huge // 100
        static let gigantic = Dimens.gigantic // 200
    }
}
