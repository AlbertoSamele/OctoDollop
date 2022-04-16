//
//  RatingSectionCell.swift
//  OctoDollop
//
//  Created by alber848 on 15/04/2022.
//

import UIKit


class RatingSectionCell: UICollectionViewCell {
    
    // MARK: - Static properties
    
    
    /// Cell reusability identifier
    public static let identifier = "RatingSectionCell"
    
    
    // MARK: - UI properties
    
    
    /// Holds all the rating views to be displayed
    private let stackView = UIStackView()
    /// Embeds `stackView`
    private let scrollView = UIScrollView()
    
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentSize = stackView.bounds.size
    }
    
    
    // MARK: - Public methods
    
    
    /// Updates the cell layout
    ///
    /// - Parameter viewModel: the cell's viewmodel
    public func configure(with viewModel: RatingSectionViewModel) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for metric in viewModel.metrics {
            stackView.addArrangedSubview(generateRatingView(for: metric))
        }
    }
    
    
    // MARK: - UI methods
    
    
    private func setupUserInterface() {
        // Sroll view
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(scrollView)
        // Stack view
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = AppAppearance.Spacing.large
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll view
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            // Stack view
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: AppAppearance.Spacing.regular),
        ])
    }
    
    
    /// - Parameter metric: the metric used to configure the view
    /// - Returns: a pre-styled rating view
    private func generateRatingView(for metric: Metric) -> UIView {
        let ratingView = RatingCircle()
        ratingView.title = metric.type.humanReadable
        ratingView.subtitle = metric.comment
        ratingView.rating = metric.score
        return ratingView
    }
    
}
