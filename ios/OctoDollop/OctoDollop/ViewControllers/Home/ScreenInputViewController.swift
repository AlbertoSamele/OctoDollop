//
//  WebViewController.swift
//  OctoDollop
//
//  Created by alber848 on 10/12/2021.
//

import UIKit
import PhotosUI


// MARK: - ScreenGatheringViewController


/// Prompts the user to select a screen to be rated
class ScreenInputViewController: UIViewController {
    
    // MARK: - UI properties
    
    
    /// Displays input gathering instructions
    private let titleLabel = UILabel()
    /// Displays "or" text separator
    private let separatorLabel = UILabel()
    /// Gathers user input
    private let textInput = UITextField()
    /// Prompts the user to confirm his input and start the evaluation process
    private let searchButton = UIButton()
    /// Prompts the user to import a screenshot from library and start the evaluation process
    private let importButton = UIButton()
    /// Action buttons height
    private let actionHeight: CGFloat = 30
    

    // MARK: - Overrides
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Styling
        setupUserInterface()
        setupConstraints()
        // Actions
        searchButton.addTarget(self, action: #selector(goButtonTapped), for: .touchUpInside)
        importButton.addTarget(self, action: #selector(importMedia), for: .touchUpInside)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    
    // MARK: - UI methods
    
    
    private func setupUserInterface() {
        // Instructions
        titleLabel.configureAsInstructionslabel(title: "Enter the url of the UI you wish to rank")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        // Textfield
        let textfieldFont = AppAppearance.Fonts.rThin16
        let textfieldColor = AppAppearance.Colors.color_FFFFFF
        textInput.attributedPlaceholder = NSAttributedString(
            string: "URL",
            attributes: [NSAttributedString.Key.foregroundColor:textfieldColor, NSAttributedString.Key.font:textfieldFont]
        )
        textInput.addPadding(.left, amount: AppAppearance.Spacing.medium)
        textInput.addPadding(.right, amount: AppAppearance.Spacing.extraLarge * 1.2)
        textInput.backgroundColor = .clear
        textInput.font = textfieldFont
        textInput.textColor = textfieldColor
        textInput.keyboardType = .URL
        textInput.layer.cornerRadius = AppAppearance.CornerRadius.small
        textInput.layer.borderColor = AppAppearance.Colors.color_49F3B1.cgColor
        textInput.layer.borderWidth = 1
        textInput.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textInput)
        // Action button
        searchButton.configureAsActionButton(image: UIImage(systemName: "arrow.right", size: 13, weight: .heavy))
        searchButton.addShadow()
        searchButton.layer.cornerRadius = actionHeight / 2
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchButton)
        // Separator
        separatorLabel.configureAsInstructionslabel(title: "- or -")
        separatorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separatorLabel)
        // Import button
        importButton.configureAsActionButton(title: "Import")
        importButton.addShadow()
        importButton.layer.cornerRadius = (actionHeight * 1.5) / 2
        importButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(importButton)
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
            textInput.heightAnchor.constraint(equalTo: searchButton.heightAnchor, multiplier: 1.5),
            // Search button
            searchButton.centerYAnchor.constraint(equalTo: textInput.centerYAnchor),
            searchButton.trailingAnchor.constraint(equalTo: textInput.trailingAnchor, constant: -AppAppearance.Spacing.small),
            searchButton.heightAnchor.constraint(equalToConstant: actionHeight),
            searchButton.widthAnchor.constraint(equalTo: searchButton.heightAnchor),
            // Separator
            separatorLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            separatorLabel.topAnchor.constraint(equalTo: textInput.bottomAnchor, constant: verticalPadding),
            // Import button
            importButton.centerXAnchor.constraint(equalTo: separatorLabel.centerXAnchor),
            importButton.topAnchor.constraint(equalTo: separatorLabel.bottomAnchor, constant: verticalPadding),
            importButton.heightAnchor.constraint(equalToConstant: actionHeight*1.5),
            importButton.widthAnchor.constraint(equalToConstant: 150),
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
    
    /// Lets the user import existing UI screenshots from his media library
    @objc private func importMedia() {
        var pickerConfig = PHPickerConfiguration()
        pickerConfig.filter = .images
        pickerConfig.selectionLimit = 1
        let pickerController = PHPickerViewController(configuration: pickerConfig)
        pickerController.delegate = self
        present(pickerController, animated: true)

    }
    
    /// Resigns first responder
    @objc private func dismissKeyboard() { view.endEditing(true) }
    
}


// MARK: - ScreenInputViewController+PHPickerViewControllerDelegate


extension ScreenInputViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        guard let assetProvider = results.first?.itemProvider, assetProvider.canLoadObject(ofClass: UIImage.self) else { return }
        
        assetProvider.loadObject(ofClass: UIImage.self) { image, _ in
            guard let uiPreview = image as? UIImage else { return }
            DispatchQueue.main.async {
                let inputViewController = InputPreviewViewController(uiPreview: uiPreview)
                let navController = UINavigationController(rootViewController: inputViewController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true)
            }
        }
    }
    
}

