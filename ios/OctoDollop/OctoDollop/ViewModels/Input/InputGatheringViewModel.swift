//
//  InputGatheringViewModel.swift
//  OctoDollop
//
//  Created by alber848 on 02/01/2022.
//

import Foundation
import CoreGraphics


// MARK: - InputGatheringViewModel


class InputGatheringViewModel {
    
    // MARK: - Binding properties
    
    
    /// Callback triggered whenever the whole grading process should be interrupted
    public var dismiss: (() -> Void)?
    /// Callback triggered whenever the rectangle surrounding the UI element currently being identified should be updated
    ///
    /// - Parameter $0: the rectangle's position on the screen
    public var updateDynamicElement: ((CGRect) -> Void)?
    /// Callback triggered whenever the rectangle surrounding the UI element currently being identified should be saved
    public var saveDynamicElement: (() -> Void)?
    
    
    // MARK: - Datasource properties
    
    
    /// The origin of the rectangle surrounding the UI element currently being identified
    public var dynamicOrigin: CGPoint?
    
    
    // MARK: - Public methods
    
    
    /// Starts identifying a UI element
    ///
    /// - Parameter point: the screen's point in which the user started identifying the element
    public func startDrawing(at point: CGPoint) { dynamicOrigin = point }
    
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
        saveDynamicElement?()
    }
    
    /// Undoes last action or prompts dismissal if no action can be undone
    public func undo() {
       //TODO: implement
        dismiss?()
    }
}