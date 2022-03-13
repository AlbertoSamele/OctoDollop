//
//  MenuController.swift
//  OctoDollop
//
//  Created by alber848 on 13/03/2022.
//

import UIKit


// MARK: - MenuController


/// Displays a menu with contextual actions
///
/// MenuControllers can be displayed only one at a time
class MenuController: UIViewController {
    
    // MARK: - Static properties
    
    
    /// `MenuController` currently being displayed
    private static var presentedMenu: MenuController?
    
    
    // MARK: - UI properties
    
    
    /// Prompts for a deletion action
    private let deleteButton = UIButton()
    /// Displays all the menu options
    private lazy var stackView: UIStackView = {
        return UIStackView(arrangedSubviews: [deleteButton])
    }()
    
    
    // MARK: - Binding properties
    
    
    /// Callback triggered whenever the delete menu button is tapped
    public var onDelete: (() -> Void)?
    
    
    // MARK: - Overrides
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Styling
        setupUserInterface()
        setupConstraints()
        // Actions
        deleteButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDeleteButtonTapped)))
        deleteButton.addTarget(self, action: #selector(onDeleteButtonTapped), for: .touchUpInside)
    }
    
    
    // MARK: - Public methods
    
    
    /// Shows the view controller
    ///
    /// - Parameters:
    ///   - viewController: the cView parent view controller
    ///   - cView: the view above which the menu controller should be displayed
    public func show(from viewController: UIViewController, above cView: UIView) {
        Self.presentedMenu?.removeFromParent()
        Self.presentedMenu?.view.removeFromSuperview()
        Self.presentedMenu = self
        viewController.addChild(self)
        didMove(toParent: viewController)
        viewController.view.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.bottomAnchor.constraint(equalTo: cView.topAnchor, constant: -AppAppearance.Spacing.small),
            view.heightAnchor.constraint(equalToConstant: 30),
            view.centerXAnchor.constraint(equalTo: cView.centerXAnchor),
        ])
    }
    
    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: flag ? 0.15 : 0,
            animations: { Self.presentedMenu?.view.alpha = 0},
            completion: { _ in
                Self.presentedMenu?.removeFromParent()
                Self.presentedMenu?.view.removeFromSuperview()
                Self.presentedMenu = nil
                completion?()
            }
        )
    }
    
    
    // MARK: - UI methods
    
    
    private func setupUserInterface() {
        // Buttons
        deleteButton.setTitle("Delete", for: .normal)
        for button in [deleteButton] {
            button.backgroundColor = AppAppearance.Colors.color_1F201F
            button.setTitleColor(AppAppearance.Colors.color_FFFFFF, for: .normal)
            button.titleLabel?.font = AppAppearance.Fonts.rMedium14
            button.layer.cornerRadius = AppAppearance.CornerRadius.small
            button.translatesAutoresizingMaskIntoConstraints = false
        }
        // Stack view
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Buttons
            deleteButton.widthAnchor.constraint(equalToConstant: 80),
            deleteButton.topAnchor.constraint(equalTo: stackView.topAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            // Stack view
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    
    // MARK: - Action methods
    
    
    /// Triggeres deletion action and dismisses
    @objc private func onDeleteButtonTapped() {
        dismiss(animated: true) { [weak self] in
            self?.onDelete?()
        }
    }
    
}
