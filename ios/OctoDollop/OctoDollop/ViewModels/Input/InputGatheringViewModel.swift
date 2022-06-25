//
//  InputGatheringViewModel.swift
//  OctoDollop
//
//  Created by alber848 on 02/01/2022.
//

import Foundation
import CoreGraphics
import UIKit


// MARK: - InputGatheringViewModel


class InputGatheringViewModel {
    
    // MARK: - Computed properties
    
    
    /// Whether there is an angoing drawing or not
    public var drawingStarted: Bool { return dynamicOrigin != nil }
    
    
    // MARK: - Binding properties
    
    
    /// Callback triggered when the user wishes to save the currently identified UI elements
    ///
    /// - Parameter $0: the identified UI elements
    public var onElementsIdentified: (([UIElement]) -> Void)?
    /// Callback triggered whenever the whole grading process should be interrupted
    public var dismiss: (() -> Void)?
    /// Callback triggered whenever the rectangle surrounding the UI element currently being identified should be updated
    ///
    /// - Parameter $0: the rectangle's position on the screen
    public var updateDynamicElement: ((CGRect) -> Void)?
    /// Callback triggered whenever the rectangle surrounding the UI element currently being identified should be saved
    public var saveDynamicElement: (() -> Void)?
    /// Callback triggered whenever the last identified UI element rectangle should be removed
    public var removeLast: (() -> Void)?
    
    
    // MARK: - Datasource properties
    
    
    /// The origin of the rectangle surrounding the UI element currently being identified
    public var dynamicOrigin: CGPoint?
    /// The number of the UI elements identified by the user
    private var identifiedElementsCount = 0
    /// The image in which the UI elements should be identified in
    public let image: UIImage
    
    
    // MARK: - Inits
    
    
    public init(image: UIImage) { self.image = image }
    
    
    // MARK: - Public methods
    
    
    /// Starts identifying a UI element
    ///
    /// - Parameter point: the screen's point in which the user started identifying the element
    public func startDrawing(at point: CGPoint) {
        dynamicOrigin = point
        updateDynamicElement?(CGRect(origin: point, size: .zero))
    }
    
    /// Updates the rectangle surrending the UI element currently being identified
    ///
    /// - Parameter point: the screen's point in which the user whises to update the origin of the rectangle surrounding the identified UI element to
    public func drawingChanged(_ point: CGPoint) {
        guard let origin = dynamicOrigin else { return }
        let width = abs(point.x - origin.x)
        let height = abs(point.y - origin.y)
        let onScreenXOrigin = min(point.x, origin.x)
        let onScreenYOrigin = min(point.y, origin.y)
        updateDynamicElement?(CGRect(x: onScreenXOrigin, y: onScreenYOrigin, width: width, height: height))
    }
    
    /// Saves the current rectangle surrounding the identified UI element
    public func endDrawing() {
        dynamicOrigin = nil
        identifiedElementsCount += 1
        saveDynamicElement?()
    }
    
    /// Undoes last action or prompts dismissal if no action can be undone
    public func undo() {
        if identifiedElementsCount > 0 {
            removeLast?()
            identifiedElementsCount -= 1
        }
        else { dismiss?() }
    }
    
    /// Saves currently identified UI elements
    ///
    /// - Parameter elements: relative coordinates of the identified UI elements
    public func saveInput(elements: [(x: Double, y: Double, width: Double, height: Double)]) {
        let models = elements.map { UIElement(x: $0.x, y: $0.y, width: $0.width, height: $0.height) }
        onElementsIdentified?(models)
        dismiss?()
    }
}
