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
    
    
    /// The screenshot in which UI elements should be identified
    private let image: UIImage
    /// Displays `image`
    private let imageView = UIImageView()
    /// Prompts the user to un-add previously identified UI elements
    private let backButton = UIButton()
    /// Prompts the user to confirm the addition of the identified UI elements
    private let confirmButton = UIButton()
    /// Displays a transparent, resizable green overlay onscreen
    private lazy var dynamicElementOverlay: UIView = {
        return generateUIElementOverlay()
    }()
    /// Button size for all rounded buttons
    private let buttonSize: CGFloat = 40
    
    
    // MARK: - Displaylogic properties
    
    
    /// The viewmodel
    private let viewModel = InputGatheringViewModel()
    /// Stores the overlays that have been permanently added to the view hierarchy
    ///
    /// `dynamicElementOverlay` is not stored here as it gets continuously added and removed from the view hierarchy.
    /// Added elements can always be removed thorugh undo actions
    private var overlays = [UIView]()
    
    
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
        imageView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(onDrag(_:))))
        backButton.addTarget(self, action: #selector(onBackButtonTapped), for: .touchUpInside)
        // Other
        setupBindings()
    }
    
    
    // MARK: - Private methods
    
    
    private func setupBindings() {
        viewModel.updateDynamicElement = { [weak self] overlayFrame in
            self?.dynamicElementOverlay.frame = overlayFrame
        }
        viewModel.saveDynamicElement = { [weak self] in
            guard let self = self else { return }
            let overlay = self.generateUIElementOverlay()
            overlay.frame = self.dynamicElementOverlay.frame
            self.view.addSubview(overlay)
            self.dynamicElementOverlay.frame = .zero
        }
        viewModel.dismiss = { [weak self] in
            self?.navigationController?.popViewController(animated: false)
        }
    }
    
    
    // MARK: - UI methods
    
    
    private func setupUserInterface() {
        view.isUserInteractionEnabled = true
        // Previewer
        imageView.image = image
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        // UI element overlay
        view.addSubview(dynamicElementOverlay)
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
    
    /// Generates a view to be used as overlay to identify UI elements
    ///
    /// - Returns: the styled overlay
    private func generateUIElementOverlay() -> UIView {
        let view = UIView()
        view.backgroundColor = AppAppearance.Colors.color_49F3B1
        view.alpha = 0.6
        return view
    }
    
    
    // MARK: - Action methods
    
    
    @objc private func onDrag(_ sender: UIPanGestureRecognizer) {
        let coordinates = sender.location(in: view)
        switch sender.state {
            case .began: viewModel.startDrawing(at: coordinates)
            case .changed: viewModel.drawingChanged(coordinates)
            case .ended: viewModel.endDrawing()
            default: break
        }
    }
    
    /// Undoes last user action
    @objc private func onBackButtonTapped() { viewModel.undo() }
}
