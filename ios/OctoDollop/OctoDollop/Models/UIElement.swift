//
//  UIElement.swift
//  OctoDollop
//
//  Created by alber848 on 02/01/2022.
//

import Foundation

struct UIElement {
    /// Identified UI element relative x position
    ///
    /// `$x \in [0, 1]$`
    let x: Double
    /// Identified UI element relative y position
    ///
    /// `$y \in [0, 1]$`
    let y: Double
    /// Identified UI element normalized width
    ///
    /// `$width \in [0, 1]$`
    let width: Double
    /// Identified UI element normalized height
    ///
    /// `$height \in [0, 1]$`
    let height: Double
    
    init(x: Double, y: Double, width: Double, height: Double) {
        guard (x >= 0 && x <= 1) && (y >= 0 && y <= 1) && (width >= 0 && width <= 1) && (height >= 0 && height <= 1)
        else { fatalError("Invalid coordinates (\(x), \(y), \(width), \(height))") }
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }
}
