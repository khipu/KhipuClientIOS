import SwiftUI

@available(iOS 13.0, *)
struct Fonts {
    
    init() {
        FontLoader.loadFonts()
    }
    
    func customFont(name: String, size: CGFloat, weight: Font.Weight) -> Font {
        if let _ = UIFont(name: name, size: size) {
            return Font.custom(name, size: size).weight(weight)
        } else {
            return Font.system(size: size, weight: weight)
        }
    }

    func font(style: FontStyle, size: CGFloat) -> Font {
        let fontName: String
        let weight: Font.Weight
        
        switch style {
        case .regular:
            fontName = "PublicSans-Regular"
            weight = .regular
        case .medium:
            fontName = "PublicSans-Medium"
            weight = .medium
        case .semiBold:
            fontName = "PublicSans-SemiBold"
            weight = .semibold
        case .bold:
            fontName = "PublicSans-Bold"
            weight = .bold
        }
        
        return customFont(name: fontName, size: size, weight: weight)
    }
    
    enum FontStyle {
        case regular
        case medium
        case semiBold
        case bold
    }
}
