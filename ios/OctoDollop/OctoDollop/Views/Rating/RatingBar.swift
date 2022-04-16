//
//  RatingBar.swift
//  OctoDollop
//
//  Created by alber848 on 16/04/2022.
//

import UIKit


/// Displays the rating for one metric in a bar
class RatingBar: UIView {
    
    // MARK: - UI properties
    
    
    /// Displays the metric's title
    private let titleLabel = UILabel()
    /// Displays the metric's rating
    private let ratingLabel = UILabel()
    /// Quantifies visually the metric's rating
    private let ratingBar = UIView()
    /// `ratingBar` horizontal constraint
    private var barHorizontalConstraint: NSLayoutConstraint?
    /// The maximum `ratingBar` width
    private let maxBarWidth = UIScreen.main.bounds.width * 0.415
    
    
    // MARK: - Computed properties
    
    
    /// `ratingBar` theme color
    private var themeColor: UIColor {
        switch (rating ?? 0) {
        case 0...30: return AppAppearance.Colors.color_FF3131
        case 31...65: return AppAppearance.Colors.color_F3FA64
        default: return AppAppearance.Colors.color_49F3B1
        }
    }
    
    
    // MARK: - Datasource properties
    
    
    /// The rating's score
    private var rating: Int?
    /// The rating's title
    public var title: String? {
        didSet { titleLabel.text = title }
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
    
    
    // MARK: - Public methods
    
    
    /// Updates the rating
    ///
    /// - Parameters:
    ///   - rating: the new rating
    ///   - animated: whether the rating change should be updated or not
    public func setRating(_ rating: Int, animated: Bool) {
        self.rating = rating
        
        barHorizontalConstraint?.constant = self.maxBarWidth * CGFloat(rating) / 100
        UIView.animate(withDuration: animated ? 0.25 : 0) {
            self.ratingLabel.text = "\(rating)"
            self.ratingBar.backgroundColor = self.themeColor
            self.ratingBar.layer.shadowColor = self.themeColor.cgColor
            self.layoutIfNeeded()
        }
    }
    
    
    // MARK: - UI methods
    
    
    private func setupUserInterface() {
        // Title
        titleLabel.textColor = AppAppearance.Colors.color_FFFFFF
        titleLabel.font = AppAppearance.Fonts.rLight21
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        // Bar
        ratingBar.backgroundColor = themeColor
        ratingBar.layer.cornerRadius = AppAppearance.CornerRadius.extraSmall
        ratingBar.addShadow()
        ratingBar.layer.shadowColor = themeColor.cgColor
        ratingBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ratingBar)
        // Rating
        ratingLabel.textColor = AppAppearance.Colors.color_FFFFFF
        ratingLabel.font = AppAppearance.Fonts.rLight14
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ratingLabel)
    }
    
    private func setupConstraints() {
        barHorizontalConstraint = ratingBar.widthAnchor.constraint(equalToConstant: maxBarWidth)
        NSLayoutConstraint.activate([
            // Title
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            // Bar
            ratingBar.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: AppAppearance.Spacing.medium),
            ratingBar.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            ratingBar.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75),
            barHorizontalConstraint!,
            // Rating label
            ratingLabel.centerYAnchor.constraint(equalTo: ratingBar.centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: ratingBar.trailingAnchor, constant: AppAppearance.Spacing.extraSmall),
        ])
    }
    
}
