//
//  RatingViewController.swift
//  OctoDollop
//
//  Created by alber848 on 14/04/2022.
//

import UIKit


/// Displays UI ratings
class RatingViewController: UIViewController {
    
    // MARK: - UI properties
    
    
    /// Displays the achieved overall rating
    private let overallRatingBar = RatingBar()
    /// Displays the achieved section rating
    private let sectionRatingBar = RatingBar()
    /// Displays the UI that was rated
    private let imageView = UIImageView()
    /// Prompts the user to dismiss the rating screen
    private let backButton = UIButton()
    /// Prompts the user to save the rating into his local DB
    private let saveButton = UIButton()
    /// Prompts the user to enter a name for the rating before saving
    private let saveTextfield = UITextField()
    ///  Displays a loader while saving operations are in progress
    private let saveLoader = UIActivityIndicatorView()
    /// Displays various metrics ratings
    private lazy var collectionView: UICollectionView = {
        return UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    }()
    /// `collectionView` flow layout
    private let flowLayout = UICollectionViewFlowLayout()
    /// Shows currently selected `collectionView` section
    private let pageIndicator = PageIndicator()
    /// `imageView` width constraint
    private var imageWidthConstraint: NSLayoutConstraint?
    /// `collectionView` height multiplier
    private let collectionHeightMultiplier = 0.3
    /// Button size
    private let buttonSize: CGFloat = 40
    
    
    // MARK: - Datasource properties
    
    
    /// The viewmodel
    private let viewModel: RatingViewModel
    /// Whether ui elements on top of `imageView` have been drawn or not
    private var elementsDrawn = false
    
    
    // MARK: - Inits
    
    
    /// - Parameters:
    ///   - rating: the achieved rating
    ///   - elements: the identified ui elements relative to the rating
    ///   - image: the UI image that was rated
    ///   - canSave: whether the rating can be saved to the local DB
    ///   - onBack: callback triggered when the view controller should be dismissed
    init(rating: Rating, elements: [UIElement], image: UIImage?, canSave: Bool, onBack: @escaping (() -> Void)) {
        self.viewModel = RatingViewModel(rating: rating, elements: elements, canSave: canSave, ui: image, onBack: onBack)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Overrides
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UI
        setupUserInterface()
        setupConstraints()
        // Actions
        backButton.addTarget(self, action: #selector(onBackButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(onSaveButtonTapped), for: .touchUpInside)
        // Delegates
        collectionView.delegate = self
        collectionView.dataSource = self
        // Other
        setupBindings()
        collectionView.register(RatingSectionCell.self, forCellWithReuseIdentifier: RatingSectionCell.identifier)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !elementsDrawn {
            // Drawing ui elements
            imageView.draw(elements: viewModel.elements)
            elementsDrawn = true
        }
    }
    
    
    // MARK: - Private methods
    
    
    private func setupBindings() {
        viewModel.onError = { [weak self] errorMessage in
            let popup = PopupViewController()
            popup.title = "Error"
            popup.subtitle = errorMessage
            self?.present(popup, animated: false)
        }
        viewModel.onSave = { [weak self] in
            self?.saveButton.isHidden = true
            let popup = PopupViewController()
            popup.title = "Success"
            popup.subtitle = "Rating saved successfully. Find it in the home screen history section!"
            self?.present(popup, animated: false)
        }
    }
    
    
    // MARK: - UI methods
    
    
    private func setupUserInterface() {
        view.backgroundColor = AppAppearance.Colors.color_0B0C0B
        // Image view
        imageView.image = viewModel.ui
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        // Collection view
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: view.bounds.width, height: view.bounds.height * collectionHeightMultiplier)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        // Page indicator
        pageIndicator.count = viewModel.ratingSectionsCount
        pageIndicator.selected = 0
        pageIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageIndicator)
        // Overall rating
        overallRatingBar.title = "Overall"
        overallRatingBar.setRating(viewModel.overallRating, animated: false)
        overallRatingBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overallRatingBar)
        // Section rating
        sectionRatingBar.title = viewModel.sectionTitle(for: 0)
        sectionRatingBar.setRating(viewModel.sectionRating(for: 0), animated: false)
        sectionRatingBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sectionRatingBar)
        // Save button
        saveButton.configureAsActionButton(title: "Save")
        saveButton.addShadow()
        saveButton.layer.cornerRadius = AppAppearance.CornerRadius.small
        saveButton.isHidden = !viewModel.canSave
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)
        // Back button
        backButton.configureAsActionButton(image: UIImage(systemName: "arrowshape.turn.up.backward.fill", size: 17, weight: .medium))
        backButton.layer.cornerRadius = buttonSize / 2
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        // Save textfield
        saveTextfield.layer.cornerRadius = AppAppearance.Spacing.small
        saveTextfield.layer.borderColor = AppAppearance.Colors.color_49F3B1.cgColor
        saveTextfield.layer.borderWidth = 1
        let paddingView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 15, height: 15)))
        saveTextfield.leftView = paddingView
        saveTextfield.rightView = paddingView
        saveTextfield.leftViewMode = .always
        saveTextfield.rightViewMode = .always
        saveTextfield.font = AppAppearance.Fonts.rLight14
        saveTextfield.attributedPlaceholder = NSAttributedString(
            string: "Rating name",
            attributes: [.font:AppAppearance.Fonts.rLight14,
                         .foregroundColor:AppAppearance.Colors.color_FFFFFF.withAlphaComponent(0.6)]
        )
        saveTextfield.textColor = AppAppearance.Colors.color_FFFFFF
        saveTextfield.translatesAutoresizingMaskIntoConstraints = false
        // Loader
        saveLoader.tintColor = AppAppearance.Colors.color_0B0C0B
        saveLoader.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveLoader)
    }
    
    private func setupConstraints() {
        imageWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        NSLayoutConstraint.activate([
            // Image view
            imageView.topAnchor.constraint(equalTo: backButton.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: overallRatingBar.topAnchor, constant: -AppAppearance.Spacing.large),
            imageWidthConstraint!,
            // Collection view
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: collectionHeightMultiplier),
            collectionView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -AppAppearance.Spacing.hyperLarge),
            // Page indicator
            pageIndicator.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            pageIndicator.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -AppAppearance.Spacing.medium),
            // Overall rating
            overallRatingBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppAppearance.Spacing.large),
            overallRatingBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppAppearance.Spacing.large),
            overallRatingBar.bottomAnchor.constraint(equalTo: sectionRatingBar.topAnchor, constant: -AppAppearance.Spacing.regular),
            // Section rating
            sectionRatingBar.leadingAnchor.constraint(equalTo: overallRatingBar.leadingAnchor),
            sectionRatingBar.trailingAnchor.constraint(equalTo: overallRatingBar.trailingAnchor),
            sectionRatingBar.bottomAnchor.constraint(equalTo: pageIndicator.topAnchor, constant: -AppAppearance.Spacing.large),
            // Save button
            saveButton.leadingAnchor.constraint(equalTo: overallRatingBar.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: overallRatingBar.trailingAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -AppAppearance.Spacing.medium),
            saveButton.heightAnchor.constraint(equalToConstant: buttonSize),
            // Back button
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppAppearance.Spacing.medium),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:  AppAppearance.Spacing.medium),
            backButton.heightAnchor.constraint(equalToConstant: buttonSize),
            backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor),
            // Save textfield
            saveTextfield.heightAnchor.constraint(equalToConstant: 35),
            // Confirm loader
            saveLoader.centerXAnchor.constraint(equalTo: saveButton.centerXAnchor),
            saveLoader.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor),
            saveLoader.heightAnchor.constraint(equalTo: saveButton.heightAnchor, multiplier: 0.8),
            saveLoader.widthAnchor.constraint(equalTo: saveLoader.heightAnchor),
        ])
    }
    
    
    // MARK: - Action methods
    
    
    /// Saves the rating to local DB
    @objc private func onSaveButtonTapped() {
        let popup = PopupViewController {
            self.saveLoader.startAnimating()
            let buttonTitle = self.saveButton.title(for: .normal)
            self.saveButton.setTitle("", for: .normal)
            self.saveButton.isEnabled = false
            self.backButton.isEnabled = false
            UIView.animate(withDuration: 0.1) {
                self.backButton.alpha = 0.7
            }
            self.viewModel.save(with: self.saveTextfield.text) {
                self.saveButton.setTitle(buttonTitle, for: .normal)
                self.saveButton.isEnabled = true
                self.backButton.isEnabled = true
                UIView.animate(withDuration: 0.1) {
                    self.backButton.alpha = 1
                }
                self.saveLoader.stopAnimating()
            }
        }
        popup.title = "Save"
        popup.subtitle = "Enter the name you wish to save the rating as"
        popup.addAccessory(saveTextfield)
        present(popup, animated: false)
    }
    
    /// Dismisses the rating screen
    @objc private func onBackButtonTapped() { viewModel.dismiss() }
    
}


// MARK: - RatingViewController+UICollectionViewDelegate+UICollectionViewDataSource


extension RatingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.ratingSectionsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RatingSectionCell.identifier, for: indexPath) as! RatingSectionCell
        cell.configure(with: viewModel.generateCellViewModel(for: indexPath.row))
        return cell
    }
    
}


// MARK: - RatingViewController+UIScrollViewDelegate


extension RatingViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scrollPercentage = scrollView.contentOffset.x / scrollView.contentSize.width
        let index = Int(floor(CGFloat(viewModel.ratingSectionsCount) * scrollPercentage))
        pageIndicator.selected = index
        sectionRatingBar.title = viewModel.sectionTitle(for: index)
        sectionRatingBar.setRating(viewModel.sectionRating(for: index), animated: true)
    }
    
}
