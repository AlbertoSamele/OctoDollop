//
//  MobileViewController.swift
//  OctoDollop
//
//  Created by alber848 on 10/12/2021.
//

import UIKit


// MARK: - MobileViewController


/// Displays mobile input gathering prompt
class MobileViewController: UIViewController {
   
    // MARK: - UI properties
    
    
    /// Displays input gathering instructions
    private let titleLabel = UILabel()
    /// Prompts the user to import a media
    private let actionButton = UIButton()
    /// Displays quick processing hints
    private let subtitleLabel = UILabel()
    /// Displays hints instruction image
    private let imageView = UIImageView()
    /// `actionButton` height
    private let buttonsHeight: CGFloat = 45
    
    
    // MARK: - Overrides
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Styling
        setupUserInterface()
        setupConstraints()
    }
    
    
    // MARK: - UI methods
    
    
    private func setupUserInterface() {
        // Instructions
        titleLabel.configureAsInstructionslabel(title: "Take a screenshot of the app screen you wish to rank and import it here")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        // Import button
        actionButton.configureAsActionButton(title: "Import")
        actionButton.layer.cornerRadius = buttonsHeight / 2
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(actionButton)
        // Hints
        subtitleLabel.configureAsInstructionslabel(title: "Feeling lazy?\nImport directly from the share menu and start ranking!")
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subtitleLabel)
        // Hints image
        imageView.image = UIImage(named: "home-mobile-hint")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
    }
    
    private func setupConstraints() {
        let horizontalPadding = AppAppearance.Spacing.large
        let verticalPadding = AppAppearance.Spacing.regular
        
        NSLayoutConstraint.activate([
            // Instructions
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            // Button
            actionButton.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            actionButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: verticalPadding),
            actionButton.heightAnchor.constraint(equalToConstant: buttonsHeight),
            actionButton.widthAnchor.constraint(equalToConstant: 150),
            // Hints title
            subtitleLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -verticalPadding*0.75),
            // Hints image
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: subtitleLabel.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
        ])
    }
}
