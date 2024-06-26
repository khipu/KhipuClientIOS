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

        var regular14: Font {
            customFont(name: "PublicSans-Regular", size: 14, weight: .medium)
        }
        var regular20: Font {
            customFont(name: "PublicSans-Regular", size: 20, weight: .medium)
        }

        var medium14: Font {
            customFont(name: "PublicSans-Medium", size: 14, weight: .medium)
        }
        var medium20: Font {
            customFont(name: "PublicSans-Medium", size: 20, weight: .medium)
        }

        var semiBold14: Font {
            customFont(name: "PublicSans-SemiBold", size: 14, weight: .semibold)
        }

        var semiBold20: Font {
            customFont(name: "PublicSans-SemiBold", size: 20, weight: .semibold)
        }

        var bold14: Font {
            customFont(name: "PublicSans-Bold", size: 14, weight: .bold)
        }

        var bold20: Font {
            customFont(name: "PublicSans-Bold", size: 20, weight: .bold)
        }
}



