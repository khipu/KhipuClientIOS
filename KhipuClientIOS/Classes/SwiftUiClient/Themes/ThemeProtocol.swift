import SwiftUI

@available(iOS 13.0, *)
protocol ThemeProtocol {
    
    func setColorSchemeAndCustomColors(colorScheme: ColorScheme, colors: KhipuColors?)
    
    var colors: Colors { get }
    
    var fonts: Fonts { get }
    
}
