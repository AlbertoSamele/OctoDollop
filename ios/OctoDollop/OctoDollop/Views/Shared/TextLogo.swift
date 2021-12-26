//
//  TextLogo.swift
//  OctoDollop
//
//  Created by alber848 on 30/11/2021.
//

import UIKit


// MARK: - TextLogo


/// Styled app's text logo
class TextLogo: UIView {
    
    // MARK: - UI properties
    
    
    /// Displays a green glowing label
    private let highlightedLabel = UILabel()
    /// Displays a white label
    private let standardLabel = UILabel()
    
    
    // MARK: - Inits
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Styling
        setupUserInterface()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI methods
    
    
    private func setupUserInterface() {
        clipsToBounds = false
        // octo
        highlightedLabel.text = "octo".uppercased()
        highlightedLabel.textColor = AppAppearance.Colors.color_49F3B1
        highlightedLabel.font = AppAppearance.Fonts.styled70
        highlightedLabel.addShadow(opacity: 0.45)
        highlightedLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(highlightedLabel)
        // dollop
        standardLabel.text = "dollop"
        standardLabel.textColor = AppAppearance.Colors.color_FFFFFF
        standardLabel.font = AppAppearance.Fonts.rLight30
        standardLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(standardLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // octo
            highlightedLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            highlightedLabel.topAnchor.constraint(equalTo: topAnchor),
            highlightedLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            // dollop
            standardLabel.leadingAnchor.constraint(equalTo: highlightedLabel.trailingAnchor),
            standardLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            standardLabel.bottomAnchor.constraint(equalTo: highlightedLabel.bottomAnchor, constant: -AppAppearance.Spacing.medium),
        ])
    }
}
