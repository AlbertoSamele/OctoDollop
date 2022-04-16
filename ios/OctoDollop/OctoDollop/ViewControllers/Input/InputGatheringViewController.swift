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
    /// Wraps `imageView` to enable zooming and scrolling
    private let scrollView = UIScrollView()
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
    private let viewModel: InputGatheringViewModel
    /// Stores the overlays that have been permanently added to the view hierarchy
    ///
    /// `dynamicElementOverlay`and `commandOverlay` are not stored here
    /// Added elements can always be removed thorugh undo actions
    private var uiOverlays = [UIView]()
    
    
    // MARK: - Inits
    
    
    /// Class init
    ///
    /// - Parameters:
    ///   - ui: the screen in which UI elements should be identified
    ///   - onElementsAdded: callback triggered once the user wishes to save all the identified UI elements
    init(ui: UIImage, _ onElementsAdded: @escaping (([UIElement]) -> Void)) {
        image = ui
        viewModel = InputGatheringViewModel()
        viewModel.onElementsIdentified = onElementsAdded
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Overrides
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Delegates
        scrollView.delegate = self
        // Styling
        setupUserInterface()
        setupConstraints()
        // Actions
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(onDrag(_:)))
        imageView.addGestureRecognizer(dragGesture)
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
        backButton.addTarget(self, action: #selector(onBackButtonTapped), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(onConfirmButtonTapped), for: .touchUpInside)
        // Delegates
        dragGesture.delegate = self
        // Other
        setupBindings()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.animateCommandOverlay(animateIn: false)
        }
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
            self.imageView.addSubview(overlay)
            self.dynamicElementOverlay.frame = .zero
            self.uiOverlays.append(overlay)
        }
        viewModel.removeLast = { [weak self] in
            let last = self?.uiOverlays.removeLast()
            last?.removeFromSuperview()
        }
        viewModel.dismiss = { [weak self] in
            self?.navigationController?.popViewController(animated: false)
        }
    }
    
    
    // MARK: - UI methods
    
    
    private func setupUserInterface() {
        view.isUserInteractionEnabled = true
        // Scrollview
        scrollView.contentSize = image.size
        let scaleWidth = UIScreen.main.bounds.width / scrollView.contentSize.width
        let scaleHeight = UIScreen.main.bounds.height / scrollView.contentSize.height
        scrollView.minimumZoomScale = min(scaleWidth, scaleHeight)
        scrollView.maximumZoomScale = 1
        scrollView.zoomScale = scrollView.minimumZoomScale
        scrollView.contentOffset = .zero
        scrollView.bounces = false
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        // Previewer
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)
        // UI element overlay
        imageView.addSubview(dynamicElementOverlay)
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
            // Scrollview
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            // Image view
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
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
    
    /// Animates in or out button components
    ///
    /// - Parameter animateIn: whether the overlay should be animated in or not
    private func animateCommandOverlay(animateIn: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.backButton.alpha = animateIn ? 1 : 0
            self.confirmButton.alpha = animateIn ? 1 : 0
        }
    }
    
    
    // MARK: - Action methods
    
    
    /// Handles drag gestures
    ///
    /// - Parameter sender: the drag gesture recognizer
    @objc private func onDrag(_ sender: UIPanGestureRecognizer) {
        let coordinates = sender.location(in: imageView)
        switch sender.state {
            case .changed: viewModel.drawingChanged(coordinates)
            case .ended: viewModel.endDrawing()
            default: break
        }
    }
    
    /// Hides or shows command buttons
    @objc private func onTap() { animateCommandOverlay(animateIn: backButton.alpha == 0) }
    
    /// Undoes last user action
    @objc private func onBackButtonTapped() { viewModel.undo() }
    
    /// Confirms and saves user input
    @objc private func onConfirmButtonTapped() {
        var coordinates: [(x: Double, y: Double, width: Double, height: Double)] = []
        for overlay in uiOverlays {
            let x = overlay.frame.origin.x / imageView.bounds.width
            let y = overlay.frame.origin.y / imageView.bounds.height
            let width = overlay.frame.width / imageView.bounds.width
            let height = overlay.frame.height / imageView.bounds.height
            coordinates.append((x: x, y: y, width: width, height: height))
        }
        viewModel.saveInput(elements: coordinates)
    }
}


// MARK: - InputGatheringViewController+UIScrollViewDelegate


extension InputGatheringViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? { return imageView }
}


// MARK: - InputGatheringViewController+UIGestureRecognizerDelegate


extension InputGatheringViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: imageView)
        if !viewModel.drawingStarted { viewModel.startDrawing(at: location) }
        return true
    }
}
