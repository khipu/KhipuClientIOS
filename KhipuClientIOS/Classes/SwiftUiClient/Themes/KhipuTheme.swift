import SwiftUI


@available(iOS 13.0, *)
class KhipuTheme: ThemeProtocol {
    
    var colors: Colors = Colors()
    var dimens: Dimens = Dimens()
    var fonts: Fonts = Fonts()

    public func setColorSchemeAndCustomColors(colorScheme: ColorScheme, colors: KhipuColors?) {
        self.colors.colorScheme = colorScheme
        if colors != nil {
            self.colors.localColors = LocalColors(colors: colors!)
        }
    }
}
