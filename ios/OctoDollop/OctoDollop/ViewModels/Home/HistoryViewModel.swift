//
//  HistoryViewModel.swift
//  OctoDollop
//
//  Created by alber848 on 19/04/2022.
//

import Foundation


class HistoryViewModel {
    
    // MARK: - Computed properties
    
    
    /// The number of saved ratings
    public var ratingsCount: Int { return ratings.count }
    
    
    // MARK: - Binding properties
    
    
    /// Callback triggered wheneever the saved ratings change
    public var onRatingsChanged: (() -> Void)?
    
    
    // MARK: - Datasource properties
    
    
    /// The ratings saved by the user
    private var ratings: [Rating]
    
    
    // MARK: - Inits
    
    
    init() {
        ratings = DataManager.shared.models()
        NotificationsManager().subscribe(observer: self, selector: #selector(ratingSaved), notification: .ratingSaved)
    }
    
    
    // MARK: - Public func
    
    
    /// - Parameter index: the index offset
    /// - Returns: the ratings at the given index offset
    public func rating(for index: Int) -> Rating {
        let sanitizedIndex = max(0, min(index, ratingsCount))
        return ratings[sanitizedIndex]
    }
    
    
    // MARK: - Private func
    
    
    @objc private func ratingSaved(_ notification: Notification) {
        ratings = DataManager.shared.models()
        onRatingsChanged?()
    }
    
}
