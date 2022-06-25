//
//  PopupViewController.swift
//  OctoDollop
//
//  Created by alber848 on 18/04/2022.
//

import UIKit


class PopupViewController: UIViewController {
    
    // MARK: - UI properties
    
    
    /// The popup view
    private let containerView = UIView()
    /// Lays out popup content horizontally
    private lazy var stackView: UIStackView = {
       return UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
    }()
    /// Displays the popup title
    private let titleLabel = UILabel()
    /// Displays the popup subtitle
    private let subtitleLabel = UILabel()
    /// Prompts the user to dismiss the popup
    private let actionButton = UIButton()
    /// Blurs the background
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    
    // MARK: - Binding properties
    
    
    /// Callback triggered when the user taps the primary call-to-action button, before dismissing
    private var onDone: (() -> Void)?
    
    
    // MARK: - Datasource properties
    
    
    /// The popup title
    public override var title: String? {
        didSet {
            titleLabel.text = title
            titleLabel.isHidden = title == nil
        }
    }
    /// The popup subtitle
    public var subtitle: String? {
        didSet {
            subtitleLabel.text = subtitle
            subtitleLabel.isHidden = subtitle == nil
        }
    }
    /// The popup primary call to action title
    public var doneTitle: String = "Ok" {
        didSet { actionButton.setTitle(doneTitle, for: .normal) }
    }
    /// Whether a keyboard is currently presented or not
    private var keyboardShown = false
    
    
    // MARK: - Inits
    
    
    public init(_ onDone: (() -> Void)? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.onDone = onDone
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Overrides
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UI
        setupUserInterface()
        setupConstraints()
        // Actions
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissVC)))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        actionButton.addTarget(self, action: #selector(onDoneButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.2) {
            self.blurEffectView.alpha = 1
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        }
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: flag ? 0.2 : 0,
            animations: {
                self.blurEffectView.alpha = 0
                self.containerView.alpha = 0
                self.containerView.transform = .identity.scaledBy(x: 1.15, y: 1.15)
            },
            completion: { _ in
                super.dismiss(animated: false, completion: completion)
            }
        )
    }
    
    
    // MARK: - UI methods
    
    
    /// Adds the given view in the popup, right above the default action title
    ///
    /// - Parameter view: the view to be added
    public func addAccessory(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
        ])
    }
    
    private func setupUserInterface() {
        view.backgroundColor = UIColor.clear
        // Blur view
        blurEffectView.alpha = 0
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurEffectView)
        // Container
        containerView.alpha = 0
        containerView.transform = .identity.scaledBy(x: 1.15, y: 1.15)
        containerView.backgroundColor = AppAppearance.Colors.color_0B0C0B
        containerView.layer.cornerRadius = AppAppearance.CornerRadius.small
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        // Stack view
        stackView.axis = .vertical
        stackView.spacing = AppAppearance.Spacing.small
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        // Title
        titleLabel.isHidden = title == nil
        titleLabel.textAlignment = .center
        titleLabel.text = title
        titleLabel.font = AppAppearance.Fonts.rLight21
        titleLabel.textColor = AppAppearance.Colors.color_FFFFFF
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        // Subtitle
        subtitleLabel.isHidden = subtitle == nil
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = subtitle
        subtitleLabel.font = AppAppearance.Fonts.rLight14
        subtitleLabel.textColor = AppAppearance.Colors.color_FFFFFF
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        // Action button
        actionButton.backgroundColor = AppAppearance.Colors.color_49F3B1
        actionButton.setTitle(doneTitle, for: .normal)
        actionButton.setTitleColor(AppAppearance.Colors.color_0B0C0B, for: .normal)
        actionButton.titleLabel?.font = AppAppearance.Fonts.rMedium16
        actionButton.layer.cornerRadius = AppAppearance.CornerRadius.small
        actionButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(actionButton)
    }
    
    private func setupConstraints() {
        let hPadding = AppAppearance.Spacing.regular
        
        NSLayoutConstraint.activate([
            // Blur view
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            // Popup
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.65),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            // Stack view
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: hPadding),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -hPadding),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: AppAppearance.Spacing.small),
            // Title
            titleLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            // Subtitle
            subtitleLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            // Action button
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            actionButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: AppAppearance.Spacing.regular),
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 35),
        ])
    }
    
    // MARK: - Action methods
    
    
    /// Dismisses the view controller
    @objc private func dismissVC() {
        if keyboardShown { view.endEditing(true) }
        else { dismiss(animated: true) }
    }
    
    @objc private func onDoneButtonTapped() {
        onDone?()
        dismiss(animated: true)
    }
    
    /// Shifts the popup up
    @objc private func keyboardWillShow() {
        keyboardShown = true
        UIView.animate(withDuration: 0.2) {
            self.containerView.transform = .identity.translatedBy(x: 0, y: -self.containerView.bounds.height)
        }
    }
    
    /// Resets the popup to its original position
    @objc private func keyboardWillHide() {
        keyboardShown = false
        UIView.animate(withDuration: 0.2) {
            self.containerView.transform = .identity
        }
    }
}
