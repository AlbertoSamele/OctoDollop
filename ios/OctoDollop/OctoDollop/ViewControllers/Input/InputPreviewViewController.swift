//
//  InputPreviewViewController.swift
//  OctoDollop
//
//  Created by alber848 on 14/12/2021.
//

import UIKit
import WebKit


// MARK: - InputPreviewViewController


/// Displays currently identified UI components and prompts
class InputPreviewViewController: UIViewController {
    
    // MARK: - UI properties
    
    
    /// Depending on the current state, prompts the user to either identify a new UI element or close the rating process alotgether
    private let xButton = UIButton()
    /// Prompts the user to un-add previously identified UI elements
    private let backButton = UIButton()
    /// Previews web UI to be rated
    ///
    /// Allows the user to adjust UI position before the actual input gathering process begins
    private let webPreviewer = WKWebView()
    /// Previews the screen in which UI elements ought to be identified and that will in the end be processed
    private let uiPreviewer = UIImageView()
    /// Bottom-right button, allows the user to either start grading or start identifying UI elements
    private let confirmButton = UIButton()
    /// Displays a black gradient on top of `webPreviewer` and `uiPreviewer`
    private let gradientLayer = CAGradientLayer()
    /// Button size for all rounded buttons
    private let buttonSize: CGFloat = 40
    
    
    // MARK: - Displaylogic properties
    
    
    /// The viewmodel
    private let viewModel: InputPreviewViewModel
    
    
    // MARK: - Inits
    
    
    init(url: URL) {
        viewModel = InputPreviewViewModel(url: url)
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    init(uiPreview: UIImage) {
        viewModel = InputPreviewViewModel(ui: uiPreview)
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
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
        updateUI(animated: false)
        // Actions
        xButton.addTarget(self, action: #selector(onXButtonTapped), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmSelection), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(onBackButtonTapped), for: .touchUpInside)
        // Other
        setupBindings()
    }
    
    
    // MARK: - Private methods
    
    
    private func setupBindings() {
        // Viewmodel
        viewModel.onStartReadingInput = { [weak self] in
            self?.updateUI(animated: true)
        }
        viewModel.identifyUIEelement = {
            // TODO: present input gathering vc
        }
        viewModel.dismiss = {
            //TODO: display dismiss confirmation popup
        }
    }
    
    
    /// Confirms current user input
    ///
    /// Either starts UI elaboration or the UI input gathering process
    @objc private func confirmSelection() {
        if viewModel.shouldGatherInput {
            // TODO: HTTP request - elaboration
        } else {
            webPreviewer.takeSnapshot(with: nil) { [weak self] screencap, error in
                // TODO: Error handling
                guard let screencap = screencap else { return }
                self?.viewModel.setTargetUI(screencap)
            }
        }
    }
    
    
    // MARK: - UI methods
    
    
    /// Updates the UI to reflect current `viewModel` state
    ///
    /// - Parameter animated: whether the UI update should be animated or not
    private func updateUI(animated: Bool) {
        if !viewModel.shouldGatherInput, let previewUrl = viewModel.url { webPreviewer.load(URLRequest(url: previewUrl)) }
        uiPreviewer.image = viewModel.uiImage
        
        if animated && viewModel.shouldGatherInput {
            backButton.transform = CGAffineTransform(scaleX: 0.87, y: 0.87)
        }
        UIView.animate(withDuration: animated ? 0.2 : 0) {
            self.confirmButton.setTitle(self.viewModel.actionTitle, for: .normal)
            self.webPreviewer.alpha = self.viewModel.shouldGatherInput ? 0 : 1
            self.uiPreviewer.alpha = self.viewModel.shouldGatherInput ? 1 : 0
            self.backButton.alpha = self.viewModel.shouldGatherInput ? 1 : 0
            self.xButton.transform = self.viewModel.shouldGatherInput ? CGAffineTransform(rotationAngle: .pi/4) : .identity
            self.backButton.transform = .identity
        }
    }
    
    private func setupUserInterface() {
        view.backgroundColor = AppAppearance.Colors.color_0B0C0B
        // Web UI previewer
        webPreviewer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webPreviewer)
        // UI previewer
        uiPreviewer.contentMode = .scaleAspectFit
        uiPreviewer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(uiPreviewer)
        // Buttons styling
        for button in [xButton, backButton, confirmButton] {
            button.contentMode = .scaleAspectFit
            button.tintColor = AppAppearance.Colors.color_0B0C0B
            button.backgroundColor = AppAppearance.Colors.color_49F3B1
            button.layer.cornerRadius = buttonSize / 2
            button.addShadow()
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
        }
        // Close button
        xButton.setImage(UIImage(systemName: "xmark", size: 17, weight: .bold), for: .normal)
        // Back button
        backButton.setImage(UIImage(systemName: "arrowshape.turn.up.backward.fill", size: 17, weight: .medium), for: .normal)
        backButton.layer.cornerRadius = buttonSize / 2
        // Confirm button
        confirmButton.setTitleColor(AppAppearance.Colors.color_0B0C0B, for: .normal)
        confirmButton.layer.cornerRadius = buttonSize / 2
        confirmButton.titleLabel?.font = AppAppearance.Fonts.rSemibold18
        confirmButton.backgroundColor = AppAppearance.Colors.color_49F3B1
        confirmButton.addShadow()
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(confirmButton)
        // Gradient
        gradientLayer.colors = [
            AppAppearance.Colors.color_0B0C0B!.cgColor,
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            AppAppearance.Colors.color_0B0C0B!.cgColor
        ]
        gradientLayer.locations = [0, 0.25, 0.75, 1.0]
        gradientLayer.frame = view.frame
        view.layer.insertSublayer(gradientLayer, above: uiPreviewer.layer)
    }
    
    private func setupConstraints() {
        let buttonPadding = AppAppearance.Spacing.medium
        
        NSLayoutConstraint.activate([
            // Close button
            xButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: buttonPadding),
            xButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: buttonPadding),
            xButton.heightAnchor.constraint(equalToConstant: buttonSize),
            xButton.widthAnchor.constraint(equalTo: xButton.heightAnchor),
            // Back button
            backButton.leadingAnchor.constraint(equalTo: xButton.trailingAnchor, constant: 1.5*buttonPadding),
            backButton.centerYAnchor.constraint(equalTo: xButton.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: buttonSize),
            backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor),
            // Web UI previewer
            webPreviewer.topAnchor.constraint(equalTo: view.topAnchor),
            webPreviewer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webPreviewer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webPreviewer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // UI previewer
            uiPreviewer.leadingAnchor.constraint(equalTo: webPreviewer.leadingAnchor),
            uiPreviewer.trailingAnchor.constraint(equalTo: webPreviewer.trailingAnchor),
            uiPreviewer.topAnchor.constraint(equalTo: webPreviewer.topAnchor),
            uiPreviewer.bottomAnchor.constraint(equalTo: webPreviewer.bottomAnchor),
            // Confirm button
            confirmButton.heightAnchor.constraint(equalToConstant: buttonSize),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -buttonPadding),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -buttonPadding),
            confirmButton.widthAnchor.constraint(equalToConstant: 3*buttonSize)
        ])
    }
    
    
    // MARK: - Action methods
    
    
    /// Prompts for dismissal or for input gathering depending on current state
    @objc private func onXButtonTapped() {
        if !viewModel.shouldGatherInput { dismiss(animated: true) }
    }
    
    /// Undoes last user action
    @objc private func onBackButtonTapped() { viewModel.undo() }
    
}
