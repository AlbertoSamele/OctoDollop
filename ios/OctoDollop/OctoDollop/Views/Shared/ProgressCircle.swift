//
//  ProgressCircle.swift
//  OctoDollop
//
//  Created by alber848 on 19/04/2022.
//

import UIKit


/// Displays a partially strokable circle
class ProgressCircle: UIView {
    
    // MARK: - UI properties
    
    
    /// Wraps `circleLayer`
    private let containerView = UIView()
    /// Displays the progress value
    private let progressLabel = UILabel()
    /// Displays a rating circle
    private let circleLayer = CAShapeLayer()
    
    
    // MARK: - Datasource properties
    
    
    /// The stroke percentage
    public var strokePercentage: CGFloat = 1 {
        didSet {
            circleLayer.strokeEnd = strokePercentage
            progressLabel.text = "\(Int(CGFloat(strokeMax-strokeMin)*strokePercentage))"
        }
    }
    /// The circle's main theme color
    public var themeColor: CGColor = AppAppearance.Colors.color_49F3B1.cgColor {
        didSet {
            circleLayer.strokeColor = themeColor
            layer.shadowColor = themeColor
        }
    }
    /// The minimum progress value
    public var strokeMin: Int = 0
    /// The maximum progress value
    public var strokeMax: Int = 100
    /// Whether the `circleLayer` path has been drawn or not
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
            let circlePath = UIBezierPath(arcCenter: containerView.center,
                                          radius: containerView.bounds.width / 2,
                                          startAngle: 1.5*Double.pi,
                                          endAngle: 3.5*Double.pi,
                                          clockwise: true)
            circleLayer.path = circlePath.cgPath
            circleDrawn = true
        }
    }
    
    
    // MARK: - UI methods
    
    
    private func setupUserInterface() {
        containerView.backgroundColor = .clear
        containerView.addShadow()
        containerView.layer.shadowColor = themeColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        // Progress label
        progressLabel.textColor = AppAppearance.Colors.color_FFFFFF
        progressLabel.font = AppAppearance.Fonts.rSemibold18
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(progressLabel)
        // Circle layer
        circleLayer.strokeColor = themeColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = 6
        circleLayer.strokeStart = 0
        circleLayer.strokeEnd = strokePercentage
        circleLayer.lineCap = .round
        containerView.layer.addSublayer(circleLayer)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container view
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            // Progress label
            progressLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            progressLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
    }
}
