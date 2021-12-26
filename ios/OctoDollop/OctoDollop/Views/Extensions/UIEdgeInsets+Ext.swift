//
//  UIEdgeInsets+Ext.swift
//  OctoDollop
//
//  Created by alber848 on 14/12/2021.
//

import UIKit


extension UIEdgeInsets {
    
    /// Sets inset to be the same all over (tlbr)
    ///
    /// - Parameter insetAmount: the edge inset amount
    init(all insetAmount: CGFloat) {
        self.init(
            top: insetAmount,
            left: insetAmount,
            bottom: insetAmount,
            right: insetAmount
        )
    }
    
}
