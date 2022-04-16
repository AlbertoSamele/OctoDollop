//
//  RatingSectionViewModel.swift
//  OctoDollop
//
//  Created by alber848 on 15/04/2022.
//

import Foundation


class RatingSectionViewModel {
    
    // MARK: - Datasource properties
    
    
    /// The section's metrics
    public let metrics: [Metric]
    
    
    // MARK: - Inits
    
    
    init(metrics: [Metric]) { self.metrics = metrics }
}
