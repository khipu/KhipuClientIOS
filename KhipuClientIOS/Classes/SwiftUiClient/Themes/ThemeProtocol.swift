//
//  ThemeProtocol.swift
//
//
//  Created by Mauricio Castillo on 16-05-24.
//

import SwiftUI
/**
 Protocol for themes
 */
@available(iOS 13.0, *)
protocol ThemeProtocol {
    
    func setColorSchemeAndCustomColors(colorScheme: ColorScheme, colors: KhipuColors?)
    
    var colors: Colors { get }
        
    var fonts: Fonts { get }
    
}
