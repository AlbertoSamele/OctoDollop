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
    
    
    /// Wraps `circleLayer`
    private let circleContainer = UIView()
    /// Displays a rating circle
    private let circleLayer = CAShapeLayer()
    /// Displays the rating score
    private let ratingLabel = UILabel()
    /// Displays the rating title
    private let titleLabel = UILabel()
    /// Displays the rating subtitle
    private let subtitleLabel = UILabel()
    /// Wraps `titleLabel` and `subtitleLabel`
    private lazy var textStack: UIStackView = {
       return UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
    }()
    
    
    // MARK: - Computed properties
    
    
    /// `circleLayer.strokeEnd`
    private var fillPercentage: CGFloat { return CGFloat(rating ?? 0) / 100.0 }
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
            if let rating = rating { ratingLabel.text = "\(rating)" }
            else { ratingLabel.text = nil }
            circleLayer.strokeEnd = fillPercentage
            circleLayer.strokeColor = strokeColor
            circleContainer.layer.shadowColor = strokeColor
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
    /// Whether the circle in `circleContainer` has already been drawn or not
    private var circleDrawn = false
    
    
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
    
    
    // MARK: - Overrides
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !circleDrawn {
            let circlePath = UIBezierPath(arcCenter: circleContainer.center,
                                          radius: circleContainer.bounds.width / 2,
                                          startAngle: 1.5*Double.pi,
                                          endAngle: 3.5*Double.pi,
                                          clockwise: true)
            circleLayer.path = circlePath.cgPath
            circleDrawn = true
        }
    }
    
    
    // MARK: - UI method
    
    
    private func setupUserInterface() {
        // Circle wrapper
        circleContainer.backgroundColor = .clear
        circleContainer.addShadow()
        circleContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(circleContainer)
        // Circle layer
        circleLayer.strokeColor = AppAppearance.Colors.color_49F3B1.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = 6
        circleLayer.strokeStart = 0
        circleLayer.strokeEnd = fillPercentage
        circleLayer.lineCap = .round
        circleContainer.layer.addSublayer(circleLayer)
        // Rating label
        ratingLabel.textColor = AppAppearance.Colors.color_FFFFFF
        ratingLabel.font = AppAppearance.Fonts.rSemibold18
        ratingLabel.text = "78"
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ratingLabel)
        // Title
        titleLabel.textColor = AppAppearance.Colors.color_FFFFFF
        titleLabel.font = AppAppearance.Fonts.rMedium16
        titleLabel.text = "Horizontal balance"
        // Subtitle
        subtitleLabel.textColor = AppAppearance.Colors.color_FFFFFF
        subtitleLabel.font = AppAppearance.Fonts.rLight14
        subtitleLabel.text = "Slightly heavier on the right"
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
            circleContainer.widthAnchor.constraint(equalToConstant: circleSize),
            circleContainer.heightAnchor.constraint(equalTo: circleContainer.widthAnchor),
            circleContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            circleContainer.topAnchor.constraint(equalTo: topAnchor),
            circleContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            // Rating
            ratingLabel.centerXAnchor.constraint(equalTo: circleContainer.centerXAnchor),
            ratingLabel.centerYAnchor.constraint(equalTo: circleContainer.centerYAnchor),
            // Text stack
            textStack.leadingAnchor.constraint(equalTo: circleContainer.trailingAnchor, constant: AppAppearance.Spacing.medium),
            textStack.centerYAnchor.constraint(equalTo: circleContainer.centerYAnchor),
            textStack.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
