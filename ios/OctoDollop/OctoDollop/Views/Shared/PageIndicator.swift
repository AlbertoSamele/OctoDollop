//
//  PageIndicator.swift
//  OctoDollop
//
//  Created by alber848 on 15/04/2022.
//

import UIKit


class PageIndicator: UIView {
    
    // MARK: - UI properties
    
    
    /// Lays out all indicators horizontally
    private let wrapperStack = UIStackView()
    
    
    // MARK: - Datasource properties
    
    
    /// The number of page indicators
    public var count: Int = 0 {
        didSet { updateUserInterface()  }
    }
    /// The indicators background color
    public var theme: UIColor = AppAppearance.Colors.color_FFFFFF {
        didSet { updateSelected() }
    }
    /// The index of the selected indicator
    public var selected: Int? {
        didSet { updateSelected() }
    }
    /// Deselected indicators alpha component
    private let deselectionAlpha = 0.6
    
    
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
    
    
    /// Updates the UI to reflect current datasource state
    private func updateUserInterface() {
        wrapperStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for i in 0..<count {
            let indicator = generateIndicator(selected: i == selected)
            wrapperStack.addArrangedSubview(indicator)
        }
    }
    
    /// Updates the indicators to reflect current `selected` state
    private func updateSelected() {
        guard let selected = selected else { return }
        for (index, indicator) in wrapperStack.arrangedSubviews.enumerated() {
            let selected = index == selected
            indicator.backgroundColor = theme.withAlphaComponent(selected ? 1 : deselectionAlpha)
        }
    }
    
    /// - Parameter selected: whether the indicator should be selected or not
    /// - Returns: styled indicator
    private func generateIndicator(selected: Bool) -> UIView {
        let view = UIView()
        let indicatorSize = 10.0
        view.backgroundColor = theme.withAlphaComponent(selected ? 1 : deselectionAlpha)
        view.layer.cornerRadius = indicatorSize / 2
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: indicatorSize),
            view.heightAnchor.constraint(equalTo: view.widthAnchor),
        ])
        return view
    }
    
    private func setupUserInterface() {
        // Stack
        wrapperStack.axis = .horizontal
        wrapperStack.distribution = .equalSpacing
        wrapperStack.alignment = .center
        wrapperStack.spacing = AppAppearance.Spacing.small
        wrapperStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(wrapperStack)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Stack
            wrapperStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            wrapperStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            wrapperStack.topAnchor.constraint(equalTo: topAnchor),
            wrapperStack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
