//
//  UIView+Ext.swift
//  OctoDollop
//
//  Created by alber848 on 30/11/2021.
//

import UIKit


extension UIView {
    
    /// Adds a pre-styled shadow
    ///
    /// - Parameters:
    ///   - radius: the shadow's radius
    ///   - opacity: the shadow's opacity
    ///   - offset: the shadow's offset
    func addShadow(radius: CGFloat = 10, opacity: Float = 0.6, offset: CGSize = CGSize(width: 0, height: 2)) {
        layer.shadowColor = AppAppearance.Colors.color_49F3B1?.cgColor
        layer.shadowRadius = 10
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
    }
    
}
