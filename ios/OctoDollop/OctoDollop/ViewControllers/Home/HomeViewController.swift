//
//  ViewController.swift
//  OctoDollop
//
//  Created by alber848 on 28/11/2021.
//

import UIKit


// MARK: - HomeViewController


/// Displays UI elaboration options
class HomeViewController: UIViewController {

    // MARK: - UI properties
    
    
    /// Displays the name of the app
    private let logo = TextLogo()
    /// Displays the home tab section pickers
    private let segmentedPicker = SegmentedControl()
    /// `collectionView` flow layout
    private let flowLayout = UICollectionViewFlowLayout()
    /// Displays home sections
    private lazy var collectionView: UICollectionView = {
       return UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    }()
    
    
    // MARK: - Displaylogic properties
    
    
    /// The viewmodel
    private let viewModel = HomeViewModel()
    
    
    // MARK: - Overrides
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Styling
        setupUserInterface()
        setupConstraints()
        // Delegates
        collectionView.delegate = self
        collectionView.dataSource = self
        // Other
        collectionView.register(HomeOptionCell.self, forCellWithReuseIdentifier: HomeOptionCell.identifier)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        flowLayout.itemSize = CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }


    // MARK: - UI methods
    
    
    private func setupUserInterface() {
        view.backgroundColor = AppAppearance.Colors.color_0B0C0B
        // logo
        logo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logo)
        // segmented control
        segmentedPicker.segmentIcons = viewModel.sectionIcons
        segmentedPicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedPicker)
        // collection view
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Logo
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AppAppearance.Spacing.medium),
            // Segmented control
            segmentedPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedPicker.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: AppAppearance.Spacing.medium),
            segmentedPicker.widthAnchor.constraint(equalTo: logo.widthAnchor, multiplier: 1.2),
            // collection view
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: segmentedPicker.bottomAnchor, constant: AppAppearance.Spacing.hyperLarge),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
}


// MARK: - HomeViewController+UICollectionViewDelegate+UICollectionViewDataSource


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.sectionControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeOptionCell.identifier, for: indexPath) as! HomeOptionCell
        
        let vcType = viewModel.sectionControllers[indexPath.row]
        cell.configure(with: vcType) { viewController in
            self.addChild(viewController)
            viewController.didMove(toParent: self)
        }
        
        return cell
    }
}

