import SwiftUI

@available(iOS 13.0, *)
class ThemeManager: ObservableObject {
    
    @Published var selectedTheme: ThemeProtocol = KhipuTheme()
    
    func setTheme(_ theme: ThemeProtocol) {
        selectedTheme = theme
    }
    
}
