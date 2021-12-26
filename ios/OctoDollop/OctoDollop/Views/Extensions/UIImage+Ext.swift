//
//  UIImage+Ext.swift
//  OctoDollop
//
//  Created by alber848 on 14/12/2021.
//

import UIKit


extension UIImage {
    
    /// Initializes UIImage with SF symbols icon
    ///
    /// - Parameters:
    ///   - systemName: the icon system name
    ///   - size: the desired icon size
    ///   - weight: the desired icon weight
    convenience init?(
        systemName: String,
        size: CGFloat,
        weight: SymbolWeight = .regular
    ) {
        self.init(
            systemName: systemName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: size, weight: weight)
        )
    }
    
}
