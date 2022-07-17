//
//  HistoryCell.swift
//  OctoDollop
//
//  Created by alber848 on 19/04/2022.
//

import UIKit


/// Displays the summary of a rating saved by the user
class HistoryCell: UITableViewCell {
    
    // MARK: - Static properties
    
    
    /// Cell reusability identifier
    public static let identifier = "HistoryCell"
    
    
    // MARK: - UI properties
    
    
    /// Wraps the rating's data
    private let containerView = UIView()
    /// Shows a colored tile
    private let colorTile = UIView()
    /// Displays the rating title
    private let titleLabel = UILabel()
    /// Displays the rating subtitle
    private let subtitleLabel = UILabel()
    /// Lays out `titleLabel` and `subtitleLabel` vertically
    private lazy var textStack: UIStackView = {
        return UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
    }()
    /// Shows the achieved rating score
    private let ratingCircle = ProgressCircle()
    /// Displays whether the cell is selected during consistency mode
    private let consistencyIndicator = UIView()
    /// `colorTle` height
    private let colorTileHeight: CGFloat = 60
    /// `consistencyIndicator` height
    private let consistencyHeight: CGFloat = 15
    
    
    // MARK: - Inits
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // UI
        setupUserInterface()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Public methods
    
    
    /// Updates the UI to display the given model's data
    ///
    /// - Parameters:
    ///   - rating: the rating to be displayed
    ///   - consistencyModeEnabled: whether consistency mode is enabled or not
    ///   - consistencySelected: whether the cell is selected during consistency mode or not
    public func configure(with rating: Rating, consistencyModeEnabled: Bool, consistencySelected: Bool) {
        titleLabel.text = rating.name
        ratingCircle.strokePercentage = CGFloat(rating.score) / 100.0
        switch rating.score {
        case 0...30: ratingCircle.themeColor = AppAppearance.Colors.color_FF3131.cgColor
        case 31...65: ratingCircle.themeColor = AppAppearance.Colors.color_F3FA64.cgColor
        default: ratingCircle.themeColor = AppAppearance.Colors.color_49F3B1.cgColor
        }
        if let date = rating.date {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "dd/MM/yy"
            let showDate = inputFormatter.string(from: date)
            subtitleLabel.text = showDate
        }
        colorTile.backgroundColor = rating.mainUIColor?.color ?? AppAppearance.Colors.color_49F3B1
        setConsistencyMode(consistencyModeEnabled, selected: consistencySelected, animated: false)
    }
    
    /// Enables or disables consistency mode with an animation
    ///
    /// - Parameters:
    ///   - enabled: whether consistency mode should be enabled or not
    ///   - selected: whether the cell is selected during consistency mode or not
    public func setConsistencyMode(_ enabled: Bool, selected: Bool) { setConsistencyMode(enabled, selected: selected, animated: true) }
    
    
    // MARK: - UI methods
    
    
    /// Enables or disables consistency mode
    ///
    /// - Parameters:
    ///   - enabled: whether consistency mode should be enabled or not
    ///   - selected: whether the cell is selected during consistency mode or not
    ///   - animated: whether the UI updated should be animated or not
    private func setConsistencyMode(_ enabled: Bool, selected: Bool, animated: Bool) {
        UIView.animate(withDuration: animated ? 0.2 : 0) {
            self.consistencyIndicator.alpha = enabled ? 1 : 0
            self.consistencyIndicator.backgroundColor = enabled && selected ? AppAppearance.Colors.color_49F3B1 : AppAppearance.Colors.color_0B0C0B
        }
    }
    
    private func setupUserInterface() {
        selectionStyle = .none
        backgroundColor = .clear
        // Container
        containerView.backgroundColor = AppAppearance.Colors.color_1F201F
        containerView.layer.cornerRadius = AppAppearance.CornerRadius.large
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        // Color tile
        colorTile.backgroundColor = UIColor.red
        colorTile.layer.cornerRadius = colorTileHeight / 2
        colorTile.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(colorTile)
        // Title label
        titleLabel.textColor = AppAppearance.Colors.color_FFFFFF
        titleLabel.font = AppAppearance.Fonts.rMedium18
        // Subtitle
        subtitleLabel.textColor = AppAppearance.Colors.color_FFFFFF
        subtitleLabel.font = AppAppearance.Fonts.rLight16
        // Stack
        textStack.axis = .vertical
        textStack.spacing = AppAppearance.Spacing.hyperSmall
        textStack.distribution = .equalSpacing
        textStack.alignment = .leading
        textStack.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(textStack)
        // Rating circle
        ratingCircle.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(ratingCircle)
        // Consistency selector
        consistencyIndicator.backgroundColor = AppAppearance.Colors.color_0B0C0B
        consistencyIndicator.layer.cornerRadius = consistencyHeight / 2
        consistencyIndicator.layer.borderWidth = 2
        consistencyIndicator.layer.borderColor = AppAppearance.Colors.color_49F3B1.cgColor
        consistencyIndicator.addShadow()
        consistencyIndicator.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(consistencyIndicator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppAppearance.Spacing.large),
            containerView.heightAnchor.constraint(equalToConstant: 110),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppAppearance.Spacing.extraLarge),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppAppearance.Spacing.extraLarge),
            // Color tile
            colorTile.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            colorTile.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: AppAppearance.Spacing.large),
            colorTile.heightAnchor.constraint(equalToConstant: colorTileHeight),
            colorTile.widthAnchor.constraint(equalTo: colorTile.heightAnchor),
            // Text stack
            textStack.leadingAnchor.constraint(equalTo: colorTile.trailingAnchor, constant: AppAppearance.Spacing.regular),
            textStack.centerYAnchor.constraint(equalTo: colorTile.centerYAnchor),
            // Rating circle
            ratingCircle.widthAnchor.constraint(equalTo: colorTile.heightAnchor, multiplier: 0.8),
            ratingCircle.heightAnchor.constraint(equalTo: ratingCircle.widthAnchor),
            ratingCircle.centerYAnchor.constraint(equalTo: colorTile.centerYAnchor),
            ratingCircle.trailingAnchor.constraint(equalTo: consistencyIndicator.leadingAnchor, constant: -AppAppearance.Spacing.regular*0.85),
            // Consistency selector
            consistencyIndicator.widthAnchor.constraint(equalToConstant: consistencyHeight),
            consistencyIndicator.heightAnchor.constraint(equalTo: consistencyIndicator.widthAnchor),
            consistencyIndicator.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -AppAppearance.Spacing.regular),
            consistencyIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
    }
}
