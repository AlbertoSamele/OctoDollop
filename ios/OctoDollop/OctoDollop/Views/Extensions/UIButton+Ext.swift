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
    func configureAsActionButton(title: String?) {
        setTitle(title, for: .normal)
        configureAsActionButton()
    }
    
    /// Styles the button
    ///
    /// - Parameter image: the button's image
    func configureAsActionButton(image: UIImage?) {
        setImage(image, for: .normal)
        configureAsActionButton()
    }
    
    private func configureAsActionButton() {
        backgroundColor = AppAppearance.Colors.color_49F3B1
        setTitleColor(AppAppearance.Colors.color_0B0C0B, for: .normal)
        tintColor = AppAppearance.Colors.color_0B0C0B
        titleLabel?.font = AppAppearance.Fonts.rSemibold18
    }
    
}
