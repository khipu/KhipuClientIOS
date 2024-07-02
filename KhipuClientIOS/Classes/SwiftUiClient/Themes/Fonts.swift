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
            print("Warning: Font \(name) not found. Using system font as fallback.")
            return Font.system(size: size, weight: weight)
        }
    }

    var regular10: Font {
        customFont(name: "PublicSans-Regular", size: 10, weight: .regular)
    }
    var regular12: Font {
        customFont(name: "PublicSans-Regular", size: 12, weight: .regular)
    }
    var regular14: Font {
        customFont(name: "PublicSans-Regular", size: 14, weight: .regular)
    }
    var regular16: Font {
        customFont(name: "PublicSans-Regular", size: 16, weight: .regular)
    }
    var regular18: Font {
        customFont(name: "PublicSans-Regular", size: 18, weight: .regular)
    }
    var regular20: Font {
        customFont(name: "PublicSans-Regular", size: 20, weight: .regular)
    }
    var regular24: Font {
        customFont(name: "PublicSans-Regular", size: 24, weight: .regular)
    }
    var medium10: Font {
        customFont(name: "PublicSans-Medium", size: 10, weight: .medium)
    }
    var medium12: Font {
        customFont(name: "PublicSans-Medium", size: 12, weight: .medium)
    }
    var medium14: Font {
        customFont(name: "PublicSans-Medium", size: 14, weight: .medium)
    }
    var medium16: Font {
        customFont(name: "PublicSans-Medium", size: 16, weight: .medium)
    }
    var medium18: Font {
        customFont(name: "PublicSans-Medium", size: 18, weight: .medium)
    }
    var medium20: Font {
        customFont(name: "PublicSans-Medium", size: 20, weight: .medium)
    }
    var medium24: Font {
        customFont(name: "PublicSans-Medium", size: 24, weight: .medium)
    }
    var semiBold10: Font {
        customFont(name: "PublicSans-SemiBold", size: 10, weight: .semibold)
    }
    var semiBold12: Font {
        customFont(name: "PublicSans-SemiBold", size: 12, weight: .semibold)
    }
    var semiBold14: Font {
        customFont(name: "PublicSans-SemiBold", size: 14, weight: .semibold)
    }
    var semiBold16: Font {
        customFont(name: "PublicSans-SemiBold", size: 16, weight: .semibold)
    }
    var semiBold18: Font {
        customFont(name: "PublicSans-SemiBold", size: 18, weight: .semibold)
    }
    var semiBold20: Font {
        customFont(name: "PublicSans-SemiBold", size: 20, weight: .semibold)
    }
    var semiBold24: Font {
        customFont(name: "PublicSans-SemiBold", size: 24, weight: .semibold)
    }
    var bold10: Font {
        customFont(name: "PublicSans-Bold", size: 10, weight: .bold)
    }
    var bold12: Font {
        customFont(name: "PublicSans-Bold", size: 12, weight: .bold)
    }
    var bold14: Font {
        customFont(name: "PublicSans-Bold", size: 14, weight: .bold)
    }
    var bold16: Font {
        customFont(name: "PublicSans-Bold", size: 16, weight: .bold)
    }
    var bold18: Font {
        customFont(name: "PublicSans-Bold", size: 18, weight: .bold)
    }
    var bold20: Font {
        customFont(name: "PublicSans-Bold", size: 20, weight: .bold)
    }
    var bold24: Font {
        customFont(name: "PublicSans-Bold", size: 24, weight: .bold)
    }
}



