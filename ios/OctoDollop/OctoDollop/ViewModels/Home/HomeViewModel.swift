//
//  HomeViewModel.swift
//  OctoDollop
//
//  Created by alber848 on 10/12/2021.
//

import Foundation
import UIKit


// MARK: - HomeViewModel


class HomeViewModel {
    
    // MARK: - HomeSection
    
    
    private enum HomeSection: CaseIterable {
        case web, mobile, history
        
        /// Section icon
        public var icon: UIImage? {
            switch self {
                case .web: return UIImage(systemName: "safari.fill")
                case .mobile: return UIImage(systemName: "applelogo")
                case .history: return UIImage(systemName: "book.fill")
            }
        }
        /// Section controller
        public var controller: UIViewController.Type {
            switch self {
                case .web: return WebViewController.self
                case .mobile: return MobileViewController.self
                case .history: return HistoryViewController.self
            }
        }
    }
    
    
    // MARK: - Computed properties
    
    
    /// Section icons sorted by the order in which they should be displayed
    public var sectionIcons: [UIImage?] {
        return sections.map { $0.icon }
    }
    /// Section view controller sorted by the order in which they should be displayed
    public var sectionControllers: [UIViewController.Type] {
        return sections.map { $0.controller }
    }
    
    
    // MARK: - Datasource properties
    
    
    /// Sections to be displayed
    private let sections: [HomeSection] = [.web, .mobile, .history]

}
