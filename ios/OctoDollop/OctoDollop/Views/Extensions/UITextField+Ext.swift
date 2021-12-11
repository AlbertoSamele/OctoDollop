//
//  UITextField+Ext.swift
//  OctoDollop
//
//  Created by alber848 on 11/12/2021.
//

import UIKit


extension UITextField {

    enum PaddingSide {
        case left, right, both
    }

    /// Adds padding to the textfield
    ///
    /// - Parameters:
    ///   - padding: where the padding should be added
    ///   - amount: the padding amount
    func addPadding(_ padding: PaddingSide, amount: CGFloat) {
        leftViewMode = .always
        layer.masksToBounds = true

        switch padding {

        case .left:
            leftViewMode = .always
            leftView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: bounds.height))
        case .right:
            rightView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: bounds.height))
            rightViewMode = .always
        case .both:
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
            leftView = paddingView
            leftViewMode = .always
            rightView = paddingView
            rightViewMode = .always
        }
    }
}
