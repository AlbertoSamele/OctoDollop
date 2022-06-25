//
//  RatingView.swift
//  OctoDollop
//
//  Created by alber848 on 15/04/2022.
//

import UIKit


/// Displays the rating for one metric in a circle
class RatingCircle: UIView {
    
    // MARK: - UI properties
    
    
    /// Shows the rating score
    private let ratingCircle = ProgressCircle()
    /// Displays the rating title
    private let titleLabel = UILabel()
    /// Displays the rating subtitle
    private let subtitleLabel = UILabel()
    /// Wraps `titleLabel` and `subtitleLabel`
    private lazy var textStack: UIStackView = {
       return UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
    }()
    
    
    // MARK: - Computed properties
    
    
    /// `circleLayer.strokeColor`
    private var strokeColor: CGColor {
        switch (rating ?? 0) {
        case 0...30: return AppAppearance.Colors.color_FF3131.cgColor
        case 31...65: return AppAppearance.Colors.color_F3FA64.cgColor
        default: return AppAppearance.Colors.color_49F3B1.cgColor
        }
    }
    
    
    // MARK: - Datasource properties
    
    
    /// The rating's score
    public var rating: Int? {
        didSet {
            ratingCircle.strokePercentage = CGFloat(rating ?? 0) / 100.0
            ratingCircle.themeColor = strokeColor
        }
    }
    /// The rating's title
    public var title: String? {
        didSet { titleLabel.text = title }
    }
    /// The rating's subtitle
    public var subtitle: String? {
        didSet { subtitleLabel.text = subtitle }
    }
    
    
    // MARK: - Inits
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // UI
        setupUserInterface()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI method
    
    
    private func setupUserInterface() {
        ratingCircle.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ratingCircle)
        // Title
        titleLabel.textColor = AppAppearance.Colors.color_FFFFFF
        titleLabel.font = AppAppearance.Fonts.rMedium16
        // Subtitle
        subtitleLabel.textColor = AppAppearance.Colors.color_FFFFFF
        subtitleLabel.font = AppAppearance.Fonts.rLight14
        // Text stack
        textStack.axis = .vertical
        textStack.distribution = .equalSpacing
        textStack.alignment = .leading
        textStack.spacing = AppAppearance.Spacing.hyperSmall
        textStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textStack)
    }
    
    private func setupConstraints() {
        let circleSize = 50.0
        
        NSLayoutConstraint.activate([
            // Circle wrapper
            ratingCircle.widthAnchor.constraint(equalToConstant: circleSize),
            ratingCircle.heightAnchor.constraint(equalTo: ratingCircle.widthAnchor),
            ratingCircle.leadingAnchor.constraint(equalTo: leadingAnchor),
            ratingCircle.topAnchor.constraint(equalTo: topAnchor),
            ratingCircle.bottomAnchor.constraint(equalTo: bottomAnchor),
            // Text stack
            textStack.leadingAnchor.constraint(equalTo: ratingCircle.trailingAnchor, constant: AppAppearance.Spacing.medium),
            textStack.centerYAnchor.constraint(equalTo: ratingCircle.centerYAnchor),
            textStack.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
