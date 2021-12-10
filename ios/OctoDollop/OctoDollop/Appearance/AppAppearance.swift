//
//  AppAppearance.swift
//  OctoDollop
//
//  Created by alber848 on 30/11/2021.
//

import Foundation
import UIKit


// MARK: - AppAppearance


/// Global styling options
enum AppAppearance {
    
    // MARK: - Colors
    
    
    /// App colors
    enum Colors {
        /// White
        static let color_FFFFFF = UIColor(named: "color_FFFFFF")
        /// Black equivalent
        static let color_0B0C0B = UIColor(named: "color_0B0C0B")
        /// Very dark gray
        static let color_1F201F = UIColor(named: "color_1F201F")
        /// Vibrant turquoise
        static let color_49F3B1 = UIColor(named: "color_49F3B1")
    }
    
    
    // MARK: - Fonts
    
    
    /// App fonts
    enum Fonts {
        /// Styled, 70 pts
        static let styled70 = UIFont(name: "aAlloyInk", size: 70)
        /// Rounded, light, 30 pts
        static let rLight30 = rounded(ofSize: 30, weight: .light)
        
        
        /// Generates a rounded system font
        ///
        /// - Parameters:
        ///   - size: the font size
        ///   - weight: the font weight
        /// - Returns: the rounded font
        private static func rounded(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
            let systemFont = UIFont.systemFont(ofSize: size, weight: weight)
            let font: UIFont
            
            if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) { font = UIFont(descriptor: descriptor, size: size) }
            else { font = systemFont }
            
            return font
        }
    }
    
    
    // MARK: - Spacing
    
    
    /// App spacing
    enum Spacing {
        /// 5 pts
        static let extraSmall: CGFloat = 5
        /// 10 pts
        static let small: CGFloat = 10
        /// 15 pts
        static let medium: CGFloat = 15
        /// 30 pts
        static let large: CGFloat = 30
    }
    
}
