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
        static let color_FFFFFF = UIColor(named: "color_FFFFFF")!
        /// Black equivalent
        static let color_0B0C0B = UIColor(named: "color_0B0C0B")!
        /// Very dark gray
        static let color_1F201F = UIColor(named: "color_1F201F")!
        /// Vibrant turquoise
        static let color_49F3B1 = UIColor(named: "color_49F3B1")!
        /// Vibrant red
        static let color_FF3131 = UIColor(named: "color_FF3131")!
        /// Vibrant yellow
        static let color_F3FA64 = UIColor(named: "color_F3FA64")!
    }
    
    
    // MARK: - Fonts
    
    
    /// App fonts
    enum Fonts {
        /// Styled, 70 pts
        static let styled70 = UIFont(name: "aAlloyInk", size: 70)
        /// Rounded, light, 30 pts
        static let rLight30 = rounded(ofSize: 30, weight: .light)
        /// Rounded, light, 21 pts
        static let rLight21 = rounded(ofSize: 21, weight: .light)
        /// Rounded, light, 14 pts
        static let rLight14 = rounded(ofSize: 14, weight: .light)
        /// Rounded, thin, 16 pts
        static let rThin16 = rounded(ofSize: 16, weight: .thin)
        /// Rounded, medium, 16 pts
        static let rMedium16 = rounded(ofSize: 16, weight: .medium)
        /// Rounded, medium, 14 pts
        static let rMedium14 = rounded(ofSize: 14, weight: .medium)
        /// Rounded, semibold, 18 pts
        static let rSemibold18 = rounded(ofSize: 18, weight: .semibold)
        
        
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
        /// 2 pts
        static let hyperSmall: CGFloat = 2.5
        /// 5 pts
        static let extraSmall: CGFloat = 5
        /// 10 pts
        static let small: CGFloat = 10
        /// 15 pts
        static let medium: CGFloat = 15
        /// 18.75 pts
        static let regular: CGFloat = 18.75
        /// 30 pts
        static let large: CGFloat = 35
        /// 40 pts
        static let extraLarge: CGFloat = 40
        /// 60 pts
        static let hyperLarge: CGFloat = 65
    }
    
    
    // MARK: - CornerRadius
    
    
    /// App corner radius
    enum CornerRadius {
        /// 10 pts
        static let small: CGFloat = 10
        /// 5 pts
        static let extraSmall: CGFloat = 4
    }
    
}
