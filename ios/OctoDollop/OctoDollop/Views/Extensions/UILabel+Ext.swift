//
//  UILabel+Ext.swift
//  OctoDollop
//
//  Created by alber848 on 11/12/2021.
//

import UIKit


extension UILabel {
    
    /// Styles the label
    ///
    /// - Parameter title: the label's title
    func configureAsInstructionslabel(title: String) {
        text = title
        textColor = AppAppearance.Colors.color_FFFFFF
        font = AppAppearance.Fonts.rLight21
        numberOfLines = 0
        textAlignment = .center
    }
}
