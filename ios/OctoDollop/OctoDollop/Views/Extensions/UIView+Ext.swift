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
    func addShadow(radius: CGFloat = 10, opacity: Float = 0.35, offset: CGSize = CGSize(width: 0, height: 2)) {
        layer.shadowColor = AppAppearance.Colors.color_49F3B1.cgColor
        layer.shadowRadius = 10
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
    }
    
    /// Changes the view's anchor point
    ///
    /// - Parameter point: the new anchor point
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var position = layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position = position
        layer.anchorPoint = point
    }
    
}
