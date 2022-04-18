//
//  Rating.swift
//  OctoDollop
//
//  Created by alber848 on 15/04/2022.
//

import Foundation

struct Rating: Codable {
    /// The metrics being evaluated
    let metrics: [MetricGroup]
    /// The overall metrics score
    let score: Int
}

struct MetricGroup: Codable {
    /// Human readable section title
    let section: String
    /// The metrics in the section
    let metrics: [Metric]
}

enum MetricType: String, Codable {
    case hBalance = "balance_horizontal", vBalance = "balance_vertical"
    case hSymmetry = "symmetry_horizontal", vSymmetry = "symmetry_vertical"
    case hEquilibrium = "equilibrium_horizontal", vEquilibrium = "equilibrium_vertical"
    
    public var humanReadable: String {
        switch self {
        case .hBalance: return "Horizontal balance"
        case .vBalance: return "Vertical balance"
        case .hSymmetry: return "Horizontal symmetry"
        case .vSymmetry: return "Vertical symmetry"
        case .hEquilibrium: return "Horizontal equilibrium"
        case .vEquilibrium: return "Vertical equilibrium"
        }
    }
}

struct Metric: Codable {
    /// The metric type
    public let type: MetricType
    /// A human readable comment explaining the metric's score
    public let comment: String
    /// The metric score
    public let score: Int
}
