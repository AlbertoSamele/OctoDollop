//
//  SegmentedControl+Accessory.swift
//  OctoDollop
//
//  Created by alber848 on 06/12/2021.
//

import UIKit


extension SegmentedControl {
    
    // MARK: - Segment
    
    
    class Segment: UIView {
        
        // MARK: - Direction
        
        
        enum Direction {
            case left, right, none
            
            public var offset: CGFloat {
                switch self {
                    case .left: return -250
                    case .right: return 250
                    case .none: return 0
                }
            }
        }
        
        
        // MARK: - UI properties
        
        
        /// The segment icon tint color
        public override var tintColor: UIColor! {
            didSet { iconView.tintColor = tintColor }
        }
        /// The segment's height constant
        private let segmentSize: CGFloat = 50
        /// Displays a highlighted indicator that marks the segment as selected
        private let selectionIndicator = UIView()
        /// Wrapper button
        private let button = UIButton()
        /// Displays segment's icon
        private let iconView = UIImageView()
        
        
        // MARK: - Binding properties
        
        
        /// Callback triggered whenever the segment gets tapped
        public var onTap: (() -> Void)?
        
        
        // MARK: - Inits
        
        
        /// Class init
        ///
        /// - Parameter image: the segment's icon
        init(image: UIImage?) {
            super.init(frame: .zero)
            // Data
            iconView.image = image
            // Styling
            setupUserInterface()
            setupConstraints()
            // Actions
            button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        // MARK: - UI methods
        
        
        /// Sets the segment as selected
        ///
        /// - Parameter direction: the direction from which the indicator should appear from
        public func select(from direction: Direction) {
            selectionIndicator.transform = .identity
                .concatenating(CGAffineTransform(translationX: direction.offset, y: 0))
            UIView.animate(withDuration: 0.25) {
                self.selectionIndicator.transform = .identity
                self.selectionIndicator.alpha = 1
                
            }
            UIView.animate(withDuration: 0.2) {
                self.layer.shadowOpacity = 0.35
            }
        }
        
        /// Sets the segment as deselected
        ///
        /// - Parameter direction: the direction from which the indicator should disappear from
        public func deselect(towards direction: Direction) {
            UIView.animate(withDuration: 0.25) {
                self.selectionIndicator.transform = .identity
                    .concatenating(CGAffineTransform(translationX: direction.offset, y: 0))
                self.selectionIndicator.alpha = 0
            }
            UIView.animate(withDuration: 0.2) {
                self.layer.shadowOpacity = 0
            }
            
        }
        
        
        private func setupUserInterface() {
            addShadow()
            layer.shadowOpacity = 0
            // Button
            button.clipsToBounds = true
            button.backgroundColor = AppAppearance.Colors.color_1F201F
            button.layer.shadowOpacity = 0
            button.layer.cornerRadius = segmentSize / 2
            button.translatesAutoresizingMaskIntoConstraints = false
            addSubview(button)
            // Indicator
            selectionIndicator.isUserInteractionEnabled = false
            selectionIndicator.backgroundColor = AppAppearance.Colors.color_49F3B1
            selectionIndicator.layer.cornerRadius = segmentSize / 2
            selectionIndicator.alpha = 0
            selectionIndicator.translatesAutoresizingMaskIntoConstraints = false
            button.addSubview(selectionIndicator)
            // Icon
            iconView.tintColor = AppAppearance.Colors.color_FFFFFF
            iconView.contentMode = .scaleAspectFit
            iconView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(iconView)
        }
        
        private func setupConstraints() {
            let verticalPadding = AppAppearance.Spacing.extraSmall
            
            NSLayoutConstraint.activate([
                // Container
                button.leadingAnchor.constraint(equalTo: leadingAnchor),
                button.topAnchor.constraint(equalTo: topAnchor),
                button.bottomAnchor.constraint(equalTo: bottomAnchor),
                button.trailingAnchor.constraint(equalTo: trailingAnchor),
                button.heightAnchor.constraint(equalToConstant: segmentSize),
                button.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 1.65),
                // Indicator
                selectionIndicator.widthAnchor.constraint(equalTo: button.widthAnchor),
                selectionIndicator.heightAnchor.constraint(equalTo: button.heightAnchor),
                selectionIndicator.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                selectionIndicator.centerXAnchor.constraint(equalTo: button.centerXAnchor),
                // Icon
                iconView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
                iconView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                iconView.topAnchor.constraint(equalTo: button.topAnchor, constant: verticalPadding),
                iconView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -verticalPadding),
            ])
        }
        
        
        // MARK: - Action methods
        
        
        /// Handles segment tap
        @objc private func handleTap() { onTap?() }
        
    }
}
