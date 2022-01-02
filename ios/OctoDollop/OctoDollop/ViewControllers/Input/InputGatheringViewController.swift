//
//  InputGatheringViewController.swift
//  OctoDollop
//
//  Created by alber848 on 29/12/2021.
//

import UIKit


// MARK: - InputGatheringViewController


class InputGatheringViewController: UIViewController {
    
    // MARK: - UI properties
    
    
    /// Displays `image`
    private let imageView = UIImageView()
    /// The screenshot in which UI elements should be identified
    private let image: UIImage
    /// Prompts the user to un-add previously identified UI elements
    private let backButton = UIButton()
    /// Prompts the user to confirm the addition of the identified UI elements
    private let confirmButton = UIButton()
    /// Button size for all rounded buttons
    private let buttonSize: CGFloat = 40
    
    
    // MARK: - Displaylogic properties
    
    
    /// The viewmodel
    private let viewModel = InputGatheringViewModel()
    
    
    // MARK: - Inits
    
    
    init(ui: UIImage) {
        image = ui
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Overrides
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Styling
        setupUserInterface()
        setupConstraints()
        // Actions
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDrag(_:))))
        backButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackButtonTapped)))
        // Other
        setupBindings()
    }
    
    
    // MARK: - Private methods
    
    
    private func setupBindings() {
        viewModel.dismiss = { [weak self] in
            self?.navigationController?.popViewController(animated: false)
        }
    }
    
    
    // MARK: - UI methods
    
    
    private func setupUserInterface() {
        // Previewer
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        // Back button
        backButton.configureAsActionButton(image: UIImage(systemName: "arrowshape.turn.up.backward.fill", size: 17, weight: .medium))
        backButton.layer.cornerRadius = buttonSize / 2
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        // Confirm button
        confirmButton.configureAsActionButton(title: "Confirm")
        confirmButton.addShadow()
        confirmButton.layer.cornerRadius = buttonSize / 2
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(confirmButton)
    }
    
    private func setupConstraints() {
        let buttonPadding = AppAppearance.Spacing.medium
        
        NSLayoutConstraint.activate([
            // Previewer
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            // Back button
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: buttonPadding),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: buttonPadding),
            backButton.heightAnchor.constraint(equalToConstant: buttonSize),
            backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor),
            // Confirm button
            confirmButton.heightAnchor.constraint(equalToConstant: buttonSize),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -buttonPadding),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -buttonPadding),
            confirmButton.widthAnchor.constraint(equalToConstant: 3*buttonSize),
        ])
    }
    
    
    // MARK: - Action methods
    
    
    @objc private func onDrag(_ sender: UIPanGestureRecognizer) {
        let coordinates = sender.location(in: view)
        print(coordinates)
    }
    
    /// Undoes last user action
    @objc private func onBackButtonTapped() { viewModel.undo() }
}
