//
//  InputPreviewViewModel.swift
//  OctoDollop
//
//  Created by alber848 on 14/12/2021.
//

import Foundation
import UIKit.UIImage


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
    ///
    /// - Parameter $0: the screenshot in which the UI element should be identified
    public var identifyUIEelement: ((UIImage) -> Void)?
    /// Callback triggered whenever a long-running asynchronous operations starts or ends
    ///
    /// - Parameter $0: whether the operation is still running or not
    public var onLoadingChanged: ((Bool) -> Void)?
    /// Callback triggered whenever a UI should be captured from the currently displayed webpage
    ///
    /// - Returns: completion handler to be called once the screenshot has been correctly captured
    public var captureWebpage: ((@escaping (UIImage) -> Void) -> Void)?
    
    
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
    
    
    /// Confirms current user input, either prompting a screen capture or sending identified UI elements for elaboration
    public func confirmInput() {
        if shouldGatherInput {
            onLoadingChanged?(true)
            // TODO: Network call
        } else {
            captureWebpage?() { [weak self] screencap in
                self?.uiImage = screencap
                self?.shouldGatherInput = true
                self?.onStartReadingInput?()
            }
        }
    }
    
    /// Dismisses the process or prompts for a new UI element to be identified depending on current app's state
    public func onSecondaryAction() {
        if let screenCap = uiImage, shouldGatherInput { identifyUIEelement?(screenCap) }
        else { dismiss?() }
    }
    
    /// Undoes last action or prompts dismissal if no action can be undone
    public func undo() {
       //TODO: implement
    }
    
}
