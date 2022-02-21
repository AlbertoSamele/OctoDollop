//
//  SegmentedControl.swift
//  OctoDollop
//
//  Created by alber848 on 30/11/2021.
//

import UIKit


// MARK: - SegmentedControl


/// Displays an animated segmented control
class SegmentedControl: UIView {
    
    // MARK: - Binding properties
    
    
    /// Callback triggered whenever a segment gets selected
    ///
    /// - Parameter $0: the selected segment index
    public var onSegmentTapped: ((Int) -> Void)?
    
    
    // MARK: - UI properties
    
    
    /// The spacing in between segments
    public var spacing: CGFloat = 0 {
        didSet { containerStackView.spacing = spacing }
    }
    /// Segment icon selected tint color
    private let selectedIconColor = AppAppearance.Colors.color_0B0C0B
    /// Segment icon deselected tint color
    private let deselectedIconColor = AppAppearance.Colors.color_FFFFFF
    /// Single segment height constant
    private let segmentHeight: CGFloat = 50
    /// Displays the segmented elements horizontally
    private let containerStackView = UIStackView()
    /// `selectionIndicator` x axis constraints, used to adjusts its position
    private var indicatorXAnchor: NSLayoutConstraint?
    
    
    // MARK: - Datasource properties
    
    
    /// The segment icons to be displayed in the segmented control
    ///
    /// Automatically updates the UI once set
    public var segmentIcons: [UIImage?] = [] {
        didSet { updateUI() }
    }
    /// The selected `segmentIcons` index
    private var selectedIndex: Int = 0
    
    
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
    
    
    /// Updates the UI to reflect current `segments` state
    ///
    /// Segments tagged 0-indexed as displayed on screen
    /// - Postcondition: `iconViews` will be populated with the UIImageViews added to the view hierarchy
    private func updateUI() {
        containerStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (i, icon) in segmentIcons.enumerated() {
            let segment = Segment(image: icon)
            segment.onTap = { self.segmentTapped(i) }
            containerStackView.addArrangedSubview(segment)
        }
        
        (containerStackView.arrangedSubviews[0] as? Segment)?.select(from: .none)
        (containerStackView.arrangedSubviews[0] as? Segment)?.tintColor = selectedIconColor
    }
    
    /// Updates selected segment UI
    ///
    /// - Parameter index: the segment's index
    @objc private func segmentTapped(_ index: Int) {
        let segments = containerStackView.arrangedSubviews.compactMap { $0 as? Segment }
        for (i, segment) in segments.enumerated() {
            UIView.animate(withDuration: 0.35) {
                segment.tintColor = i == index ? self.selectedIconColor : self.deselectedIconColor
            }
            
        }
        
        if index > selectedIndex {
            segments[selectedIndex].deselect(towards: .right)
            segments[index].select(from: .left)
        } else if index < selectedIndex {
            segments[selectedIndex].deselect(towards: .left)
            segments[index].select(from: .right)
        }
        selectedIndex = index
        
        onSegmentTapped?(index)
    }
    
    private func setupUserInterface() {
        clipsToBounds = false
        // Stack view
        containerStackView.axis = .horizontal
        containerStackView.alignment = .center
        containerStackView.distribution = .equalSpacing
        containerStackView.spacing = spacing
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Stack view
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStackView.topAnchor.constraint(equalTo: topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
}
