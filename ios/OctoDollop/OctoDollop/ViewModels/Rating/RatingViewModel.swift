//
//  RatingViewModel.swift
//  OctoDollop
//
//  Created by alber848 on 15/04/2022.
//

import Foundation
import UIKit


class RatingViewModel {
    
    
    // MARK: - Computed properties
    
    
    /// The number of metrics categories
    public var ratingSectionsCount: Int { return rating.metrics.count }
    /// The achieved overeall rating
    public var overallRating: Int { return rating.score }
    
    
    // MARK: - Binding properties
    
    
    /// Callback triggered whenever the rating screen should be dismissed
    private var onBack: (() -> Void)
    
    
    // MARK: - Datasource properties
    
    
    /// The UI rating
    private let rating: Rating
    /// The UI elements relative to the rating
    public let elements: [UIElement]
    /// Whether the rating can be saved to the local DB
    public let canSave: Bool
    /// The UI subject of the rating
    public let ui: UIImage?
    
    
    // MARK: - Inits
    
    
    init(rating: Rating, elements: [UIElement], canSave: Bool, ui: UIImage?, onBack: @escaping (() -> Void)) {
        self.rating = rating
        self.canSave = canSave
        self.onBack = onBack
        self.ui = ui
        self.elements = elements
    }
    
    
    // MARK: - Public methods
    
    
    /// - Parameter index: the cell's index offset
    /// - Returns: the cell's viewmodel
    public func generateCellViewModel(for index: Int) -> RatingSectionViewModel {
        return RatingSectionViewModel(metrics: rating.metrics[index].metrics)
    }
    
    /// - Parameter index: the rating section's index offset
    /// - Returns: the rating section title
    public func sectionTitle(for index: Int) -> String {
        return rating.metrics[index].section.firstUppercased
    }
    
    /// - Parameter index: the rating section's index offset
    /// - Returns: the rating section overall score
    public func sectionRating(for index: Int) -> Int {
        let sectionScores = rating.metrics[index].metrics.compactMap({ $0.score }).reduce(0, +)
        return Int(sectionScores / rating.metrics[index].metrics.count)
    }
    
    /// Dismisses the rating screen
    public func dismiss() { onBack() }
}
