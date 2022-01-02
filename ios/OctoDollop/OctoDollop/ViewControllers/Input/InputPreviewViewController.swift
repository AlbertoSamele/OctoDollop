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
    /// Prompts the user to undo previous action
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
    /// The identified ui elements currently added to the view hierarchy
    private var uiElements: [UIView] = []
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
        confirmButton.addTarget(self, action: #selector(onConfirmButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(onBackButtonTapped), for: .touchUpInside)
        // Other
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTransition(animateIn: true)
    }
    
    
    // MARK: - Private methods
    
    
    private func setupBindings() {
        // Viewmodel
        viewModel.onStartReadingInput = { [weak self] in
            self?.updateUI(animated: true)
        }
        viewModel.onUpdateUI = { [weak self] elements in
            guard let self = self else { return }
            self.uiElements.forEach { $0.removeFromSuperview() }
            self.uiElements.removeAll()
            for element in elements {
                let elementView = self.generateUIElementOverlay()
                let x = element.x * self.uiPreviewer.bounds.width
                let y = element.y * self.uiPreviewer.bounds.height
                let width = element.width * self.uiPreviewer.bounds.width
                let height = element.height * self.uiPreviewer.bounds.height
                elementView.frame = CGRect(x: x, y: y, width: width, height: height)
                self.view.addSubview(elementView)
                self.uiElements.append(elementView)
            }
        }
        viewModel.identifyUIEelement = { [weak self] screen in
            let vc = InputGatheringViewController(ui: screen) { self?.viewModel.addElements($0) }
            self?.animateTransition(animateIn: false) {
                self?.navigationController?.pushViewController(vc, animated: false)
            }
        }
        viewModel.captureWebpage = { [weak self] completion in
            self?.webPreviewer.takeSnapshot(with: nil) { screencap, error in
                // TODO: Error handling
                guard let screencap = screencap else { return }
                completion(screencap)
            }
        }
        viewModel.dismiss = { [weak self] in
            // TODO: Dismiss confirmation popup
            self?.dismiss(animated: true)
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
    
    /// Animates view controller in/out during transitions (pushes, pops, etc)
    ///
    /// - Parameters:
    ///   - animateIn: whether the ui elements should be animated in or not
    ///   - completion: callback triggered once all animations finished playing
    private func animateTransition(animateIn: Bool, _ completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2) {
            self.gradientLayer.opacity = animateIn ? 1 : 0
            var inTransforms: CGAffineTransform = .identity
            if self.viewModel.shouldGatherInput { inTransforms = inTransforms.concatenating(CGAffineTransform(rotationAngle: .pi/4)) }
            self.xButton.transform = animateIn ?
            inTransforms : self.xButton.transform.concatenating(CGAffineTransform(scaleX: 0.001, y: 0.001))
        }
        UIView.animate(
            withDuration: 0.2,
            delay: 0.05,
            animations: {
                let translation = self.buttonSize + 1.5*AppAppearance.Spacing.medium
                self.backButton.transform = animateIn ?
                    .identity :
                    .identity.concatenating(CGAffineTransform(translationX: -translation, y: 0))
            },
            completion: { _ in completion?() }
        )
    }
    
    private func setupUserInterface() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = AppAppearance.Colors.color_0B0C0B
        // Web UI previewer
        webPreviewer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webPreviewer)
        // UI previewer
        uiPreviewer.contentMode = .scaleAspectFit
        uiPreviewer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(uiPreviewer)
        // Close button
        xButton.configureAsActionButton(image: UIImage(systemName: "xmark", size: 17, weight: .bold))
        xButton.layer.cornerRadius = buttonSize / 2
        xButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(xButton)
        // Back button
        backButton.configureAsActionButton(image: UIImage(systemName: "arrowshape.turn.up.backward.fill", size: 17, weight: .medium))
        backButton.layer.cornerRadius = buttonSize / 2
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        // Confirm button
        confirmButton.configureAsActionButton(title: nil)
        confirmButton.addShadow()
        confirmButton.layer.cornerRadius = buttonSize / 2
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
    
    
    /// Prompts for dismissal or for input gathering depending on current state
    @objc private func onXButtonTapped() { viewModel.onSecondaryAction() }
    
    /// Undoes last user action
    @objc private func onBackButtonTapped() { viewModel.undo() }
    
    /// Confirms current user input
    @objc private func onConfirmButtonTapped() { viewModel.confirmInput() }
    
}
