//
//  Rating.swift
//  OctoDollop
//
//  Created by alber848 on 15/04/2022.
//

import Foundation
import CoreData
import UIKit

struct Rating: Codable, Hashable {
    /// The metrics being evaluated
    let metrics: [MetricGroup]
    /// The overall metrics score
    let score: Int
    /// The rating name
    private(set) var name: String?
    /// Local filesystem path to rating image
    private(set) var imagePath: String?
    /// The date in which the rating was created
    private(set) var date: Date?
    /// The elements associated with the rating
    private(set) var elements: [UIElement]?
    /// The rated UI main theme color
    private(set) var mainUIColor: CodableColor?
    
    mutating func setName(_ name: String) { self.name = name }
    mutating func setImagePath(_ path: String?) { imagePath = path }
    mutating func setDate(_ date: Date) { self.date = date }
    mutating func setElements(_ elements: [UIElement]) { self.elements = elements }
    mutating func setMainColor(_ color: UIColor) { mainUIColor = CodableColor(uiColor: color) }
}

struct CodableColor: Codable, Hashable {
    private var r: CGFloat = 1
    private var g: CGFloat = 1
    private var b: CGFloat = 1
    private var a: CGFloat = 1
    
    public var color: UIColor { return UIColor(red: r, green: g, blue: b, alpha: 1)}
    
    init(uiColor : UIColor) { uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) }
}

struct MetricGroup: Codable, Hashable {
    /// Human readable section title
    let section: String
    /// The metrics in the section
    let metrics: [Metric]
}

enum MetricType: String, Codable, Hashable {
    case hBalance = "balance_horizontal", vBalance = "balance_vertical"
    case hSymmetry = "symmetry_horizontal", vSymmetry = "symmetry_vertical"
    case hEquilibrium = "equilibrium_horizontal", vEquilibrium = "equilibrium_vertical"
    case density = "harmony_density", proportion = "harmony_proportion"
    
    public var humanReadable: String {
        switch self {
        case .hBalance: return "Horizontal balance"
        case .vBalance: return "Vertical balance"
        case .hSymmetry: return "Horizontal symmetry"
        case .vSymmetry: return "Vertical symmetry"
        case .hEquilibrium: return "Horizontal equilibrium"
        case .vEquilibrium: return "Vertical equilibrium"
        case .density: return "Density"
        case .proportion: return "Proportion"
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

struct Metric: Codable, Hashable {
    /// The metric type
    public let type: MetricType
    /// A human readable comment explaining the metric's score
    public let comment: String
    /// The metric score
    public let score: Int
}
