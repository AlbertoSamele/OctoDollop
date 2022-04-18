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
    
    
    /// The currently displayed menu controller
    private var menuController: MenuController?
    /// Depending on the current state, prompts the user to either identify a new UI element or close the rating process alotgether
    private let xButton = UIButton()
    /// Prompts the user to automatically identify UI elements through AI
    private let aiButton = UIButton()
    /// Displays a loader while the AI is elaborating the image
    private let aiLoader = UIActivityIndicatorView()
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
    private var uiElements: [(element: UIElement, view: UIView)] = []
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
        aiButton.addTarget(self, action: #selector(onAIButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(onBackButtonTapped), for: .touchUpInside)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onViewTapped)))
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
        viewModel.onUndo = { [weak self] count in
            guard let self = self else { return }
            let toBeRemoved = self.uiElements.suffix(count)
            toBeRemoved.forEach { $0.view.removeFromSuperview() }
            if count < self.uiElements.count { self.uiElements.removeLast(count) }
        }
        viewModel.onUpdateUI = { [weak self] elements in
            guard let self = self else { return }
            self.uiElements.forEach { $0.view.removeFromSuperview() }
            self.uiElements.removeAll()
            self.uiElements = self.uiPreviewer.draw(elements: elements)
            self.uiElements.forEach({
                $0.view.isUserInteractionEnabled = true
                $0.view.addGestureRecognizer(
                    UILongPressGestureRecognizer(target: self, action: #selector(self.onUIElementLongPressed(_:)))
                )
            })
        }
        viewModel.onRating = { [weak self] rating, elements, image in
            guard let self = self else { return }
            let ratingViewController = RatingViewController(rating: rating, elements: elements, image: image, canSave: true) {
                self.dismiss(animated: true)
            }
            self.navigationController?.pushViewController(ratingViewController, animated: true)
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
            self.aiButton.alpha = self.viewModel.shouldGatherInput ? 1 : 0
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
        uiPreviewer.isUserInteractionEnabled = true
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
        // AI button
        aiButton.configureAsActionButton(image: UIImage(systemName: "brain.head.profile", size: 17, weight: .medium))
        aiButton.layer.cornerRadius = buttonSize / 2
        aiButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(aiButton)
        // AI loader
        aiLoader.tintColor = AppAppearance.Colors.color_0B0C0B
        aiLoader.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(aiLoader)
        // Confirm button
        confirmButton.configureAsActionButton(title: nil)
        confirmButton.addShadow()
        confirmButton.layer.cornerRadius = buttonSize / 2
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(confirmButton)
        // Gradient
        gradientLayer.colors = [
            AppAppearance.Colors.color_0B0C0B.cgColor,
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            AppAppearance.Colors.color_0B0C0B.cgColor
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
            // AI button
            aiButton.leadingAnchor.constraint(equalTo: xButton.trailingAnchor, constant: 1.5*buttonPadding),
            aiButton.centerYAnchor.constraint(equalTo: xButton.centerYAnchor),
            aiButton.heightAnchor.constraint(equalToConstant: buttonSize),
            aiButton.widthAnchor.constraint(equalTo: aiButton.heightAnchor),
            // AI loader
            aiLoader.centerYAnchor.constraint(equalTo: aiButton.centerYAnchor),
            aiLoader.centerXAnchor.constraint(equalTo: aiButton.centerXAnchor),
            aiLoader.widthAnchor.constraint(equalTo: aiButton.widthAnchor, multiplier: 0.8),
            aiLoader.heightAnchor.constraint(equalTo: aiLoader.widthAnchor),
            // Back button
            backButton.leadingAnchor.constraint(equalTo: aiButton.trailingAnchor, constant: 1.5*buttonPadding),
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
    
    /// Marks the given view as having been annotated
    ///
    /// - Parameter elementView: the view to which the annotation view will be added to
    private func addAnnotationView(to elementView: UIView) {
        let annotationSize: CGFloat = 30
        let annotationButton = UIButton()
        annotationButton.configureAsActionButton(image: UIImage(systemName: "doc.fill", size: 13, weight: .medium))
        annotationButton.tintColor = AppAppearance.Colors.color_49F3B1
        annotationButton.backgroundColor = AppAppearance.Colors.color_0B0C0B
        annotationButton.layer.cornerRadius = annotationSize / 2
        annotationButton.translatesAutoresizingMaskIntoConstraints = false
        elementView.addSubview(annotationButton)
        NSLayoutConstraint.activate([
            annotationButton.centerYAnchor.constraint(equalTo: elementView.topAnchor),
            annotationButton.centerXAnchor.constraint(equalTo: elementView.trailingAnchor),
            annotationButton.widthAnchor.constraint(equalToConstant: annotationSize),
            annotationButton.heightAnchor.constraint(equalTo: annotationButton.widthAnchor),
        ])
    }
    
    // MARK: - Action methods
    
    
    /// Prompts for dismissal or for input gathering depending on current state
    @objc private func onXButtonTapped() { viewModel.onSecondaryAction() }
    
    /// Undoes last user action
    @objc private func onBackButtonTapped() { viewModel.undo() }
    
    /// Starta AI image processing
    @objc private func onAIButtonTapped() {
        aiLoader.startAnimating()
        let buttonImage = aiButton.image(for: .normal)
        aiButton.setImage(nil, for: .normal)
        viewModel.startAIProcessing() { [weak self] in
            self?.aiLoader.stopAnimating()
            self?.aiButton.setImage(buttonImage, for: .normal)
        }
    }
    
    /// Shows contextual menu options from the sender's view
    ///
    /// - Parameter sender: the gesture recognizer that triggered the action
    @objc private func onUIElementLongPressed(_ sender: UILongPressGestureRecognizer) {
        guard let object = sender.view else { return }
        menuController = MenuController()
        menuController?.show(from: self, above: object)
        menuController?.onDelete = { [weak self] in
            object.removeFromSuperview()
            guard let self = self, let index = self.uiElements.firstIndex(where: { $0.view == object }) else { return }
            self.viewModel.removeElement(self.uiElements[index].element)
            self.uiElements.remove(at: index)
        }
        menuController?.onAnnotate = { [weak self] annotation in 
            guard let self = self, let index = self.uiElements.firstIndex(where: { $0.view == object }) else { return }
            self.viewModel.annotate(self.uiElements[index].element, with: annotation)
            self.addAnnotationView(to: self.uiElements[index].view)
        }
    }
    
    /// Dismisses `menuController`
    @objc private func onViewTapped() { menuController?.dismiss(animated: true) }
    
    /// Confirms current user input
    @objc private func onConfirmButtonTapped() { viewModel.confirmInput() }
    
}
