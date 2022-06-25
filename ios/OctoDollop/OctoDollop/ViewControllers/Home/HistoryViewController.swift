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
    
    
    /// Displays saved ratings summary
    private let tableView = UITableView()
    /// Empty state image
    private let placeholderImage = UIImageView()
    /// Empty state title
    private let placeholderTitle = UILabel()
    /// Lays out `placeholderImage`and `placeholderTitle` vertically
    private lazy var emptyPlaceholder: UIStackView = {
       return UIStackView(arrangedSubviews: [placeholderImage, placeholderTitle])
    }()
    
    
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
        // Other
        setupBindings()
        tableView.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.identifier)
    }
    
    
    // MARK: - Private methods
    
    
    private func setupBindings() {
        viewModel.onRatingsChanged = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.tableView.isHidden = self.viewModel.ratingsCount == 0
            self.emptyPlaceholder.isHidden = !self.tableView.isHidden
        }
    }
    
    
    // MARK: - UI methods
    
    
    private func setupUserInterface() {
        // Tableview
        tableView.isHidden = viewModel.ratingsCount == 0
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
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
            // Tableview
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
}


// MARK: - HistoryViewController+UITableViewDelegate+UITableViewDataSource


extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.ratingsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.identifier, for: indexPath) as! HistoryCell
        cell.configure(with: viewModel.rating(for: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rating = viewModel.rating(for: indexPath.row)
        let ratingVC = RatingViewController(rating: rating, elements: rating.elements ?? [], image: try? DataManager.shared.image(for: rating), canSave: false) {
            self.navigationController?.popViewController(animated: true)
        }
        navigationController?.pushViewController(ratingVC, animated: true)
    }

}
