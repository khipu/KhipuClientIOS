import SwiftUI

@available(iOS 13.0, *)
class LocalColors {
    
    var lightBackground: Color?
    var lightOnBackground: Color?
    var lightPrimary: Color?
    var lightOnPrimary: Color?
    var lightTopBarContainer: Color?
    var lightOnTopBarContainer: Color?
    var darkBackground: Color?
    var darkOnBackground: Color?
    var darkPrimary: Color?
    var darkOnPrimary: Color?
    var darkTopBarContainer: Color?
    var darkOnTopBarContainer: Color?
    
    init(){}
    
    init(colors: KhipuColors) {
        if(colors.lightBackground != nil) {
            self.lightBackground = Color(hexString: colors.lightBackground!)
        }
        if(colors.lightOnBackground != nil) {
            self.lightOnBackground = Color(hexString: colors.lightOnBackground!)
        }
        if(colors.lightPrimary != nil) {
            self.lightPrimary = Color(hexString: colors.lightPrimary!)
        }
        if(colors.lightOnPrimary != nil) {
            self.lightOnPrimary = Color(hexString: colors.lightOnPrimary!)
        }
        if(colors.lightTopBarContainer != nil) {
            self.lightTopBarContainer = Color(hexString: colors.lightTopBarContainer!)
        }
        if(colors.lightOnTopBarContainer != nil) {
            self.lightOnTopBarContainer = Color(hexString: colors.lightOnTopBarContainer!)
        }
        if(colors.darkBackground != nil) {
            self.darkBackground = Color(hexString: colors.darkBackground!)
        }
        if(colors.darkOnBackground != nil) {
            self.darkOnBackground = Color(hexString: colors.darkOnBackground!)
        }
        if(colors.darkPrimary != nil) {
            self.darkPrimary = Color(hexString: colors.darkPrimary!)
        }
        if(colors.darkOnPrimary != nil) {
            self.darkOnPrimary = Color(hexString: colors.darkOnPrimary!)
        }
        if(colors.darkTopBarContainer != nil) {
            self.darkTopBarContainer = Color(hexString: colors.darkTopBarContainer!)
        }
        if(colors.darkOnTopBarContainer != nil) {
            self.darkOnTopBarContainer = Color(hexString: colors.darkOnTopBarContainer!)
        }
    }
}
