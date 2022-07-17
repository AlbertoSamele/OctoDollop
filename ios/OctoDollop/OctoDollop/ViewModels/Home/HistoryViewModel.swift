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
    
    
    /// Callback triggered whenever the saved ratings change
    public var onRatingsChanged: (() -> Void)?
    /// Callback triggered whenever the consistency between ratings should be computed
    ///
    /// - Parameter $0: the ratings whose consistency should be computed
    public var onComputeConsistency: (([Rating]) -> Void)?
    /// Callback triggered whenever a `Rating`'s details should be shown
    ///
    /// - Parameter $0: the rating to be shown
    public var onPresentRating: ((Rating) -> Void)?
    /// Callback triggered whenever consistency mode state changed
    ///
    /// - Parameter $0: whether consistency mode is enabled or not
    public var onConsistencyModeChanged: ((Bool) -> Void)?
    /// Callback triggered whenever the consistency selection state changed for a rating
    ///
    /// - Parameters:
    ///   - $0: the rating's index
    ///   - $1: whether the rating is selected or not
    public var onConsistencyStateChanged: ((Int, Bool) -> Void)?
    /// Callback triggered whenever an error happens
    ///
    /// - Parameter $0: the error message
    public var onError: ((String) -> Void)?
    
    
    // MARK: - Datasource properties
    
    
    /// The ratings saved by the user
    private var ratings: [Rating]
    /// Whether consistency mode is currently enabled or not
    private(set) var isConsistencyMode = false
    /// The ratings that have been seletced during consistency mode
    private var selectedConsistencyRatings: Set<Rating> = []
    
    
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
    
    /// Handles rating selection action
    ///
    /// - Parameter index: the index offset
    public func selectRating(at index: Int) {
        let sanitizedIndex = max(0, min(index, ratingsCount))
        if isConsistencyMode {
            let rating = ratings[sanitizedIndex]
            if selectedConsistencyRatings.contains(rating) { selectedConsistencyRatings.remove(rating) }
            else { selectedConsistencyRatings.insert(rating) }
            onConsistencyStateChanged?(index, selectedConsistencyRatings.contains(rating))
        }
        else { onPresentRating?(ratings[sanitizedIndex]) }
    }
    
    /// Enables or disables consistency mode
    public func toggleConsistencyMode() {
        if isConsistencyMode && selectedConsistencyRatings.count < 2 {
            onError?("Please select at least 2 ratings")
            return
        }
        
        if isConsistencyMode { onComputeConsistency?(Array(selectedConsistencyRatings)) }
        isConsistencyMode.toggle()
        selectedConsistencyRatings = []
        onConsistencyModeChanged?(isConsistencyMode)
        
    }
    
    /// - Parameter index: the index offset of the target rating
    /// - Returns: whether the target rating is selected during consistency mode or not
    public func isRatingSelected(at index: Int) -> Bool {
        let sanitizedIndex = max(0, min(index, ratingsCount))
        return selectedConsistencyRatings.contains(ratings[sanitizedIndex])
    }
    
    
    // MARK: - Private func
    
    
    @objc private func ratingSaved(_ notification: Notification) {
        ratings = DataManager.shared.models()
        onRatingsChanged?()
    }
    
}
