//
//  InputPreviewViewModel.swift
//  OctoDollop
//
//  Created by alber848 on 14/12/2021.
//

import Foundation
import UIKit


// MARK: - InputPreviewViewModel


class InputPreviewViewModel {
    
    // MARK: - Computed properties
    
    
    /// Confirm action title
    public var actionTitle: String { return shouldGatherInput ? "Elaborate" : "Confirm" }
    
    
    // MARK: - Datasource properties
    
    
    /// URL from which the UI to be graded should be gathered from
    public let url: URL?
    /// The UI to be graded
    private(set) var uiImage: UIImage?
    /// Whether the user should be identifying UI elements
    private(set) var shouldGatherInput = false
    
    
    // MARK: - Binding properties
    
    
    /// Callback triggered when the user should start identifying UI elements
    public var onStartReadingInput: (() -> Void)?
    /// Callback triggered whenever the whole grading process should be interrupted
    public var dismiss: (() -> Void)?
    /// Callback triggered whenever the user should be prompted to identify a new UI element
    public var identifyUIEelement: (() -> Void)?
    
    
    // MARK: - Inits
    
    
    /// Class init
    ///
    /// - Parameter url: the URL from which UI to be graded should be gathered from
    init(url: URL) { self.url = url }
    
    /// Class init
    ///
    /// - Parameter ui: the screenshot of the UI to be graded
    init(ui: UIImage) {
        url = nil // URL is nil as the UI doesn't have to be retrieved from the web
        uiImage = ui
        shouldGatherInput = true
    }
    
    
    // MARK: - Public methods
    
    
    /// Updates the datasource screen where the UI elements should be identified
    ///
    /// - Parameter image: the target UI screen
    public func setTargetUI(_ image: UIImage) {
        shouldGatherInput = true
        uiImage = image
        onStartReadingInput?()
    }
    
    /// Undoes last action or prompts dismissal if no action can be undone
    public func undo() {
       //TODO: implement
    }
    
}
