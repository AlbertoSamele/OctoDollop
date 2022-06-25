//
//  UIImageView+Ext.swift
//  OctoDollop
//
//  Created by alber848 on 16/04/2022.
//

import UIKit
import AVFoundation


extension UIImageView {
    
    typealias UIComponent = (element: UIElement, view: UIView)
    /// Draws UI elements as green overlays on top of the image view
    ///
    /// - Parameter elements: the UI elements to be drawn
    /// - Returns: the element models mapped to their drawn views
    @discardableResult
    internal func draw(elements: [UIElement]) -> [UIComponent] {
        guard let imageSize = self.image?.size else { return [] }
        var elementViews: [UIComponent] = []
        let imageRect = AVMakeRect(aspectRatio: imageSize, insideRect: bounds)
        
        for element in elements {
            let elementView = generateUIElementOverlay()
            let x = element.x * imageRect.width + (bounds.width - imageRect.width) / 2
            let y = element.y * imageRect.height + (bounds.height - imageRect.height) / 2
            let width = element.width * imageRect.width
            let height = element.height * imageRect.height
            elementView.frame = CGRect(x: x, y: y, width: width, height: height)
            addSubview(elementView)
            elementViews.append((element: element, view: elementView))
        }
        
        return elementViews
    }
    
    /// Generates a view to be used as overlay to identify UI elements
    ///
    /// - Returns: the styled overlay
    private func generateUIElementOverlay() -> UIView {
        let view = UIView()
        view.backgroundColor = AppAppearance.Colors.color_49F3B1
        view.alpha = 0.6
        return view
    }
    
}
