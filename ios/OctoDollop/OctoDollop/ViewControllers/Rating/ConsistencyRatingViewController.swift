//
//  ConsistencyRatingViewController.swift
//  OctoDollop
//
//  Created by alber848 on 26/06/2022.
//

import Foundation
import UIKit


/// Shows the consistency ratings of distinct `Rating` objects
class ConsistencyRatingViewController: UIViewController {
    
    // MARK: - UI properties
    
    
    /// Wraps all the content
    private let containerView = UIView()
    /// Displays the consistency ratings
    private let ratingBar = RatingBar()
    
    
    // MARK: - Datasource properties
    
    
    /// The viewmodel
    private let viewModel: ConsistencyRatingViewModel
    
    
    // MARK: - Inits
    
    
    /// Class init
    ///
    /// - Parameter ratings: the ratings whose consistency should be computed
    init(ratings: [Rating]) {
        viewModel = ConsistencyRatingViewModel(ratings: ratings)
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Overridden methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UI
        setupUserInterface()
        setupConstraints()
        // Actions
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackgroundTapped)))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = AppAppearance.Colors.color_0B0C0B.withAlphaComponent(0.6)
        }
    }
    
    
    // MARK: - UI methods
    
    
    private func setupUserInterface() {
        view.backgroundColor = .clear
        // Container view
        containerView.backgroundColor = AppAppearance.Colors.color_1F201F
        containerView.layer.cornerRadius = AppAppearance.CornerRadius.large
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        // Rating bar
        ratingBar.title = "Consistency"
        ratingBar.setRating(viewModel.consistency, animated: false)
        ratingBar.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(ratingBar)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container view
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            // Rating
            ratingBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: AppAppearance.Spacing.regular),
            ratingBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -AppAppearance.Spacing.regular),
            ratingBar.topAnchor.constraint(equalTo: containerView.topAnchor, constant: AppAppearance.Spacing.extraLarge),
            ratingBar.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor, constant: -AppAppearance.Spacing.extraLarge),
        ])
    }
    
    
    // MARK: - Actions
    
    
    @objc private func onBackgroundTapped() {
        UIView.animate(withDuration: 0.1) {
            self.view.backgroundColor = .clear
        }
        dismiss(animated: true)
    }
    
}
