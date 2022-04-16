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
    
    // MARK: - Annotations
    
    
    private enum Annotation: CaseIterable {
        case misplaced
        case unclear
        case small
        case big
        case useless
        case redundant
        
        public var description: String {
            switch self {
            case .misplaced: return "Misplaced"
            case .unclear: return "Unclear usage"
            case .small: return "Too small"
            case .big: return "Too big"
            case .useless: return "Not of any use"
            case .redundant: return "Redundant"
            }
        }
    }
    
    
    // MARK: - Static properties
    
    
    /// `MenuController` currently being displayed
    private static var presentedMenu: MenuController?
    
    
    // MARK: - UI properties
    
    
    /// Prompts for a deletion action
    private let deleteButton = UIButton()
    /// Prompts for an annotation action
    private let annotateButton = UIButton()
    /// Shows annotation options
    private let pickerView = UIPickerView()
    /// Toolbar shown contextually with `pickerView`
    private let pickerToolbar = UIToolbar()
    /// Prompts to confirm `pickerView` selection in `pickerToolbar`
    private let pickerToolbarDone = UIBarButtonItem()
    /// Prompts to cancel `pickerView` presentation in  `pickerToolbar`
    private let pickerToolbarCancel = UIBarButtonItem()
    /// Empty, invisible textfield solely used to display `pickerView` inside a keyboard-like view
    private let pickerTextfield = UITextField(frame: .zero)
    /// Displays all the menu options
    private lazy var stackView: UIStackView = {
        return UIStackView(arrangedSubviews: [deleteButton, annotateButton])
    }()
    
    
    // MARK: - Binding properties
    
    
    /// Callback triggered whenever the delete menu button is tapped
    public var onDelete: (() -> Void)?
    /// Callback triggered whenever the annotate menu button is tapped
    ///
    /// - Parameter $0: the annotation
    public var onAnnotate: ((String) -> Void)?
    
    
    // MARK: - Overrides
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Styling
        setupUserInterface()
        setupConstraints()
        // Actions
        deleteButton.addTarget(self, action: #selector(onDeleteButtonTapped), for: .touchUpInside)
        annotateButton.addTarget(self, action: #selector(onAnnotateButtonTapped), for: .touchUpInside)
        pickerToolbarDone.target = self
        pickerToolbarDone.action = #selector(onPickerDoneTapped)
        pickerToolbarCancel.target = self
        pickerToolbarCancel.action = #selector(onPickerCancelTapped)
        // Delegates
        pickerView.dataSource = self
        pickerView.delegate = self
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
        annotateButton.setTitle("Annotate", for: .normal)
        for button in [deleteButton, annotateButton] {
            button.backgroundColor = AppAppearance.Colors.color_1F201F
            button.setTitleColor(AppAppearance.Colors.color_FFFFFF, for: .normal)
            button.titleLabel?.font = AppAppearance.Fonts.rMedium14
            button.layer.cornerRadius = AppAppearance.CornerRadius.extraSmall
            button.translatesAutoresizingMaskIntoConstraints = false
        }
        // Stack view
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 0.5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        // Picker toolbar
        
        pickerToolbarDone.title = "Done"
        pickerToolbarCancel.title = "Cancel"
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        pickerToolbar.setItems([pickerToolbarCancel, spaceButton, pickerToolbarDone], animated: false)
        pickerToolbar.translatesAutoresizingMaskIntoConstraints = false
        // Textfield
        pickerTextfield.inputView = pickerView
        pickerTextfield.inputAccessoryView = pickerToolbar
        view.addSubview(pickerTextfield)
    }
    
    private func setupConstraints() {
        let buttonWidth: CGFloat = 80
        NSLayoutConstraint.activate([
            // Buttons
            deleteButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            deleteButton.topAnchor.constraint(equalTo: stackView.topAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            annotateButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            annotateButton.topAnchor.constraint(equalTo: stackView.topAnchor),
            annotateButton.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
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
    
    /// Shows annotation options and prompts the user to pick one
    @objc private func onAnnotateButtonTapped() { pickerTextfield.becomeFirstResponder() }
    
    /// Dismissed `pickerView`
    @objc private func onPickerCancelTapped() { pickerTextfield.resignFirstResponder() }
    
    /// Confirms `pickerView` selection
    @objc private func onPickerDoneTapped() {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            let selectedRow = self.pickerView.selectedRow(inComponent: 0)
            self.onAnnotate?(Annotation.allCases[selectedRow].description)
        }
    }
    
}


// MARK: - MenuController+UIPickerViewDataSource+UIPickerViewDelegate


extension MenuController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Annotation.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Annotation.allCases[row].description
    }
    
}
