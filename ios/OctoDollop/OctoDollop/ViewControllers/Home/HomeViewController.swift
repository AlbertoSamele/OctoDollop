//
//  ViewController.swift
//  OctoDollop
//
//  Created by alber848 on 28/11/2021.
//

import UIKit


// MARK: - HomeViewController


/// Displays UI elaboration options
class HomeViewController: UIViewController {

    // MARK: - UI properties
    
    
    /// Displays the name of the app
    private let logo = TextLogo()
    /// Displays the home tab section pickers
    private let segmentedPicker = SegmentedControl()
    
    
    // MARK: - Overrides
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Styling
        setupUserInterface()
        setupConstraints()
    }


    // MARK: - UI methods
    
    
    private func setupUserInterface() {
        view.backgroundColor = AppAppearance.Colors.color_0B0C0B
        // logo
        logo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logo)
        // segmented control
        segmentedPicker.segmentIcons = [UIImage(systemName: "safari.fill"), UIImage(systemName: "applelogo"), UIImage(systemName: "book.fill")]
        segmentedPicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedPicker)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Logo
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AppAppearance.Spacing.medium),
            // Segmented control
            segmentedPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedPicker.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: AppAppearance.Spacing.medium),
            segmentedPicker.widthAnchor.constraint(equalTo: logo.widthAnchor, multiplier: 1.2),
        ])
    }
    
}

