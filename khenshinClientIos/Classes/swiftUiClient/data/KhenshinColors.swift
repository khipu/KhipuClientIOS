//
//  KhenshinColors.swift
//  APNGKit
//
//  Created by Mauricio Castillo on 06-05-24.
//

import Foundation

public struct KhenshinColors: Codable {
    let lightBackground: String?
    let lightOnBackground: String?
    let lightPrimary: String?
    let lightOnPrimary: String?
    let lightTopBarContainer: String?
    let lightOnTopBarContainer: String?
    let darkBackground: String?
    let darkOnBackground: String?
    let darkPrimary: String?
    let darkOnPrimary: String?
    let darkTopBarContainer: String?
    let darkOnTopBarContainer: String?

    private init(lightBackground: String? = nil,
         lightOnBackground: String? = nil,
         lightPrimary: String? = nil,
         lightOnPrimary: String? = nil,
         lightTopBarContainer: String? = nil,
         lightOnTopBarContainer: String? = nil,
         darkBackground: String? = nil,
         darkOnBackground: String? = nil,
         darkPrimary: String? = nil,
         darkOnPrimary: String? = nil,
         darkTopBarContainer: String? = nil,
         darkOnTopBarContainer: String? = nil) {
        self.lightBackground = lightBackground
        self.lightOnBackground = lightOnBackground
        self.lightPrimary = lightPrimary
        self.lightOnPrimary = lightOnPrimary
        self.lightTopBarContainer = lightTopBarContainer
        self.lightOnTopBarContainer = lightOnTopBarContainer
        self.darkBackground = darkBackground
        self.darkOnBackground = darkOnBackground
        self.darkPrimary = darkPrimary
        self.darkOnPrimary = darkOnPrimary
        self.darkTopBarContainer = darkTopBarContainer
        self.darkOnTopBarContainer = darkOnTopBarContainer
    }
    
    public class Builder {
        
        public init(){}
        
        var _lightBackground: String?
        var _lightOnBackground: String?
        var _lightPrimary: String?
        var _lightOnPrimary: String?
        var _lightTopBarContainer: String?
        var _lightOnTopBarContainer: String?
        var _darkBackground: String?
        var _darkOnBackground: String?
        var _darkPrimary: String?
        var _darkOnPrimary: String?
        var _darkTopBarContainer: String?
        var _darkOnTopBarContainer: String?
        
        public func lightBackground(_ lightBackground: String) -> Builder{
            self._lightBackground = lightBackground
            return self
        }
        public func lightOnBackground(_ lightOnBackground: String) -> Builder{
            self._lightOnBackground = lightOnBackground
            return self
        }
        public func lightPrimary(_ lightPrimary: String) -> Builder{
            self._lightPrimary = lightPrimary
            return self
        }
        public func lightOnPrimary(_ lightOnPrimary: String) -> Builder{
            self._lightOnPrimary = lightOnPrimary
            return self
        }
        public func lightTopBarContainer(_ lightTopBarContainer: String) -> Builder{
            self._lightTopBarContainer = lightTopBarContainer
            return self
        }
        public func lightOnTopBarContainer(_ lightOnTopBarContainer: String) -> Builder{
            self._lightOnTopBarContainer = lightOnTopBarContainer
            return self
        }
        public func darkBackground(_ darkBackground: String) -> Builder{
            self._darkBackground = darkBackground
            return self
        }
        public func darkOnBackground(_ darkOnBackground: String) -> Builder{
            self._darkOnBackground = darkOnBackground
            return self
        }
        public func darkPrimary(_ darkPrimary: String) -> Builder{
            self._darkPrimary = darkPrimary
            return self
        }
        public func darkOnPrimary(_ darkOnPrimary: String) -> Builder{
            self._darkOnPrimary = darkOnPrimary
            return self
        }
        public func darkTopBarContainer(_ darkTopBarContainer: String) -> Builder{
            self._darkTopBarContainer = darkTopBarContainer
            return self
        }
        public func darkOnTopBarContainer(_ darkOnTopBarContainer: String) -> Builder{
            self._darkOnTopBarContainer = darkOnTopBarContainer
            return self
        }
        
        public func build() -> KhenshinColors {
            return KhenshinColors(
                lightBackground: self._lightBackground,
                lightOnBackground: self._lightOnBackground,
                lightPrimary: self._lightPrimary,
                lightOnPrimary: self._lightOnPrimary,
                lightTopBarContainer: self._lightTopBarContainer,
                lightOnTopBarContainer: self._lightOnTopBarContainer,
                darkBackground: self._darkBackground,
                darkOnBackground: self._darkOnBackground,
                darkPrimary: self._darkPrimary,
                darkOnPrimary: self._darkOnPrimary,
                darkTopBarContainer: self._darkTopBarContainer,
                darkOnTopBarContainer: self._darkOnTopBarContainer
            )
        }
        
        
    }
    
}

