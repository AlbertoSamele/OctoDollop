//
//  HomeOptionCell.swift
//  OctoDollop
//
//  Created by alber848 on 10/12/2021.
//

import UIKit


// MARK: - HomeOptionDisplayable


protocol HomeOptionDisplayable: UIViewController {
    init()
}


// MARK: - HomeOptionCell


/// Displays a viewcontroller embedded in a collection view cell
class HomeOptionCell: UICollectionViewCell {
    
    // MARK: - Static properties
    
    
    /// Cell reusability identifier
    public static let identifier = "HomeOptionCell"
    
    
    // MARK: - UI properties
    
    
    /// Viewcontroller whose view is currently added to the view hierarchy
    private(set) var viewController: UIViewController?
    
    
    // MARK: - Inits
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Styling
        setupUserInterface()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Public methods
    
    
    /// Displays given view controller
    ///
    /// - Parameters:
    ///   - viewControllerType: the view controller class to be displayed
    ///   - onAdd: callback triggered before the viewController view gets added to the view hierarchy
    public func configure(with viewControllerType: UIViewController.Type, _ onAdd: @escaping ((UIViewController) -> Void)) {
        guard viewControllerType != type(of: viewController) else { return }
        viewController = viewControllerType.init(nibName: nil, bundle: nil)
        
        guard let viewController = viewController else { return }
        viewController.view.removeFromSuperview()
        onAdd(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(viewController.view)
        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            viewController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    
    // MARK: - UI methods
    
    
    private func setupUserInterface() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
}
