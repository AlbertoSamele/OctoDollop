//
//  WebViewController.swift
//  OctoDollop
//
//  Created by alber848 on 10/12/2021.
//

import UIKit


// MARK: - WebViewController


/// Displays web input gathering prompt
class WebViewController: UIViewController {
    
    // MARK: - UI properties
    
    
    /// Displays input gathering instructions
    private let titleLabel = UILabel()
    /// Gathers user input
    private let textInput = UITextField()
    /// Prompts the user to confirm his input and start the evaluation process
    private let actionButton = UIButton()
    /// `textInput` and `actionButton` height
    private let componentsHeight: CGFloat = 45
    

    // MARK: - Overrides
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Styling
        setupUserInterface()
        setupConstraints()
        // Actions
        actionButton.addTarget(self, action: #selector(goButtonTapped), for: .touchUpInside)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    
    // MARK: - UI methods
    
    
    private func setupUserInterface() {
        // Instructions
        titleLabel.configureAsInstructionslabel(title: "Enter the url of the website you wish to rank")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        // Textfield
        let textfieldFont = AppAppearance.Fonts.rThin16
        let textfieldColor = AppAppearance.Colors.color_FFFFFF
        textInput.attributedPlaceholder = NSAttributedString(
            string: "URL",
            attributes: [NSAttributedString.Key.foregroundColor:textfieldColor!, NSAttributedString.Key.font:textfieldFont]
        )
        textInput.addPadding(.both, amount: AppAppearance.Spacing.medium)
        textInput.backgroundColor = .clear
        textInput.font = textfieldFont
        textInput.textColor = textfieldColor
        textInput.layer.cornerRadius = AppAppearance.CornerRadius.small
        textInput.layer.borderColor = AppAppearance.Colors.color_49F3B1?.cgColor
        textInput.layer.borderWidth = 1
        textInput.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textInput)
        // Action button
        actionButton.configureAsActionButton(title: "Go")
        actionButton.layer.cornerRadius = componentsHeight / 2
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(actionButton)
    }
    
    private func setupConstraints() {
        let horizontalPadding = AppAppearance.Spacing.large
        let verticalPadding = AppAppearance.Spacing.regular
        
        NSLayoutConstraint.activate([
            // Instructions
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            // Textfield
            textInput.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            textInput.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            textInput.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: verticalPadding),
            textInput.heightAnchor.constraint(equalToConstant: componentsHeight),
            // Button
            actionButton.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            actionButton.topAnchor.constraint(equalTo: textInput.bottomAnchor, constant: verticalPadding),
            actionButton.heightAnchor.constraint(equalTo: textInput.heightAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 82.5),
        ])
    }
    
    
    // MARK: - Action methods
    
    
    /// Starts elaboration of the webpage at the inputted URL
    @objc private func goButtonTapped() {
        // TODO: Error handling
        guard let urlString = textInput.text, let url = URL(string: urlString) else { return }
        let inputViewController = InputPreviewViewController(url: url)
        let navController = UINavigationController(rootViewController: inputViewController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    /// Resigns first responder
    @objc private func dismissKeyboard() { view.endEditing(true) }
    
}
