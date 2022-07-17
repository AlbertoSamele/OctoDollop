//
//  HistoryViewController.swift
//  OctoDollop
//
//  Created by alber848 on 10/12/2021.
//

import UIKit


// MARK: - HistoryViewController


/// Displays list of saved UI ratings
class HistoryViewController: UIViewController {
    
    // MARK: - UI properties
    
    
    /// Prompts the user to select the ratings to compute the consistency of
    private let consistencyButton = UIButton()
    /// Displays saved ratings summary
    private let tableView = UITableView()
    /// Lays out `consistencyButton` and `tableView` vertically
    private lazy var ratingsStack: UIStackView = {
        return UIStackView(arrangedSubviews: [consistencyButton, tableView])
    }()
    /// Empty state image
    private let placeholderImage = UIImageView()
    /// Empty state title
    private let placeholderTitle = UILabel()
    /// Lays out `placeholderImage`and `placeholderTitle` vertically
    private lazy var emptyPlaceholder: UIStackView = {
       return UIStackView(arrangedSubviews: [placeholderImage, placeholderTitle])
    }()
    /// `consistencyButton` height
    private let actionHeight: CGFloat = 45
    
    
    // MARK: - Datasource properties
    
    
    /// The view model
    private let viewModel = HistoryViewModel()
    
    
    // MARK: - Overrides
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UI
        setupUserInterface()
        setupConstraints()
        // Delegates
        tableView.delegate = self
        tableView.dataSource = self
        // Actions
        consistencyButton.addTarget(self, action: #selector(onConsistencyButtonTapped), for: .touchUpInside)
        // Other
        setupBindings()
        tableView.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.identifier)
    }
    
    
    // MARK: - Private methods
    
    
    private func setupBindings() {
        viewModel.onRatingsChanged = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.consistencyButton.isHidden = self.viewModel.ratingsCount < 2
            self.tableView.isHidden = self.viewModel.ratingsCount == 0
            self.emptyPlaceholder.isHidden = !self.tableView.isHidden
        }
        viewModel.onPresentRating = { [weak self] rating in
            guard let self = self else { return }
            
            let ratingVC = RatingViewController(
                rating: rating,
                elements: rating.elements ?? [],
                image: try? DataManager.shared.image(for: rating),
                canSave: false,
                onBack: { self.navigationController?.popViewController(animated: true) }
            )
            self.navigationController?.pushViewController(ratingVC, animated: true)
        }
        viewModel.onConsistencyModeChanged = { [weak self] consistencyEnabled in
            guard let self = self else { return }
            self.consistencyButton.setTitle(consistencyEnabled ? "Compute" : "Get consistency", for: .normal)
            for cell in self.tableView.subviews.compactMap({ $0 as? HistoryCell }) {
                let cellIndex = self.tableView.indexPath(for: cell)
                let isCellSelected = consistencyEnabled && cellIndex != nil ? self.viewModel.isRatingSelected(at: cellIndex!.row) : false
                cell.setConsistencyMode(consistencyEnabled, selected: isCellSelected)
            }
        }
        viewModel.onConsistencyStateChanged = { [weak self] ratingIndex, isSelected in
            (self?.tableView.cellForRow(at: IndexPath(row: ratingIndex, section: 0)) as? HistoryCell)?.setConsistencyMode(true, selected: isSelected)
        }
        viewModel.onComputeConsistency = { [weak self] ratings in
            let consistencyViewController = ConsistencyRatingViewController(ratings: ratings)
            self?.present(consistencyViewController, animated: true)
        }
        viewModel.onError = { [weak self] errorMessage in
            let popup = PopupViewController()
            popup.title = "Error"
            popup.subtitle = errorMessage
            self?.present(popup, animated: false)
        }
    }
    
    
    // MARK: - UI methods
    
    
    private func setupUserInterface() {
        // Rating stack
        ratingsStack.axis = .vertical
        ratingsStack.distribution = .equalSpacing
        ratingsStack.alignment = .center
        ratingsStack.spacing = AppAppearance.Spacing.extraLarge
        ratingsStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ratingsStack)
        // Consistency button
        consistencyButton.configureAsActionButton(title: "Get consistency")
        consistencyButton.addShadow()
        consistencyButton.isHidden = viewModel.ratingsCount < 2
        consistencyButton.layer.cornerRadius = actionHeight / 2
        consistencyButton.translatesAutoresizingMaskIntoConstraints = false
        // Tableview
        tableView.showsVerticalScrollIndicator = false
        tableView.isHidden = viewModel.ratingsCount == 0
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        // Placeholder image
        placeholderImage.image = UIImage(named: "EmptyPlaceholder")
        placeholderImage.contentMode = .scaleAspectFit
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        // Placeholder title
        placeholderTitle.textColor = AppAppearance.Colors.color_FFFFFF
        let placeholderText = NSMutableAttributedString(string: "No ratings\n", attributes: [.font:AppAppearance.Fonts.rLight21])
        placeholderText.append(NSAttributedString(string: "Saved ratings will appear here...\nso far you don't have any!", attributes: [.font:AppAppearance.Fonts.rLight14]))
        placeholderTitle.attributedText = placeholderText
        placeholderTitle.numberOfLines = 0
        placeholderTitle.textAlignment = .center
        placeholderTitle.translatesAutoresizingMaskIntoConstraints = false
        // Placeholder stack
        emptyPlaceholder.isHidden = !tableView.isHidden
        emptyPlaceholder.axis = .vertical
        emptyPlaceholder.spacing = AppAppearance.Spacing.medium
        emptyPlaceholder.distribution = .equalSpacing
        emptyPlaceholder.alignment = .center
        emptyPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyPlaceholder)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Rating stack
            ratingsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ratingsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ratingsStack.topAnchor.constraint(equalTo: view.topAnchor),
            // Consistency button
            consistencyButton.heightAnchor.constraint(equalToConstant: actionHeight),
            consistencyButton.widthAnchor.constraint(equalToConstant: 200),
            // Tableview
            tableView.leadingAnchor.constraint(equalTo: ratingsStack.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: ratingsStack.trailingAnchor),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.95),
            // Empty placeholder
            emptyPlaceholder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyPlaceholder.topAnchor.constraint(equalTo: view.topAnchor),
            // Placeholder image
            placeholderImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            placeholderImage.heightAnchor.constraint(equalTo: placeholderImage.widthAnchor),
            // Placeholder title
            placeholderTitle.widthAnchor.constraint(equalTo: placeholderImage.widthAnchor, multiplier: 0.75),
        ])
    }
    
    
    // MARK: - Action methods
    
    
    /// Toggles consistency mode
    @objc private func onConsistencyButtonTapped() { viewModel.toggleConsistencyMode() }
    
}


// MARK: - HistoryViewController+UITableViewDelegate+UITableViewDataSource


extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.ratingsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.identifier, for: indexPath) as! HistoryCell
        cell.configure(
            with: viewModel.rating(for: indexPath.row),
            consistencyModeEnabled: viewModel.isConsistencyMode,
            consistencySelected: viewModel.isRatingSelected(at: indexPath.row)
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectRating(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }

}
