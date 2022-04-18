//
//  String+Ext.swift
//  OctoDollop
//
//  Created by alber848 on 17/04/2022.
//

import Foundation


extension StringProtocol {
    var firstUppercased: String { prefix(1).uppercased() + dropFirst().lowercased() }
    var firstCapitalized: String { prefix(1).capitalized + dropFirst().lowercased() }
}
