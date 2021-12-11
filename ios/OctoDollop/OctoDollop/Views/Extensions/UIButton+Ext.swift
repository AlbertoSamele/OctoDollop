//
//  UIButton+Ext.swift
//  OctoDollop
//
//  Created by alber848 on 11/12/2021.
//

import UIKit


extension UIButton {
    
    /// Styles the button
    ///
    /// - Parameter title: the button's title
    func configureAsActionButton(title: String) {
        backgroundColor = AppAppearance.Colors.color_49F3B1
        setTitle(title, for: .normal)
        setTitleColor(AppAppearance.Colors.color_0B0C0B, for: .normal)
        titleLabel?.font = AppAppearance.Fonts.rSemibold18
    }
    
}
