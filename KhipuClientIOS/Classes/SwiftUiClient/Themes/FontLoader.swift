import UIKit
import SwiftUI

public class FontLoader {
    public static func loadFonts() {
        let bundle = Bundle(for: FontLoader.self)
        let resourceBundleURL = bundle.url(forResource: "KhipuClientIOS", withExtension: "bundle")
        let resourceBundle = resourceBundleURL != nil ? Bundle(url: resourceBundleURL!) : bundle
        
        let fontNames = [
            "PublicSans-Bold",
            "PublicSans-Medium",
            "PublicSans-Regular",
            "PublicSans-SemiBold"
        ]
        
        fontNames.forEach { fontName in
            if !isFontRegistered(fontName: fontName) {
                guard let url = resourceBundle?.url(forResource: fontName, withExtension: "ttf") else {
                    return
                }
                let result = CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
                if !result {
                    print("Failed to register font: \(fontName)")
                }
            }
        }
    }
    
    private static func isFontRegistered(fontName: String) -> Bool {
        let font = UIFont(name: fontName, size: 12)
        return font != nil
    }
}

