//
//  InputPreviewViewModel.swift
//  OctoDollop
//
//  Created by alber848 on 14/12/2021.
//

import Foundation
import UIKit.UIImage
import Vision


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
    /// Added UI elements
    ///
    /// Divided into blocks, where each block represent all elements added during a single session
    private var additionHistory: [Set<UIElement>] = []
    
    
    // MARK: - Binding properties
    
    
    /// Callback triggered when the user should start identifying UI elements
    public var onStartReadingInput: (() -> Void)?
    /// Callback triggered whenever the whole grading process should be interrupted
    public var dismiss: (() -> Void)?
    /// Callback triggered whenever the user should be prompted to identify a new UI element
    ///
    /// - Parameter $0: the screenshot in which the UI element should be identified
    public var identifyUIEelement: ((UIImage) -> Void)?
    /// Callback triggered whenever new UI elements should be displayed
    ///
    /// - Parameter $0: the newly identified UI elements
    public var onUpdateUI: (([UIElement]) -> Void)?
    /// Callback triggered whenever an element identification action should be undone
    ///
    /// - Parameter $0: the number of UI elements the undo action removed
    public var onUndo: ((Int) -> Void)?
    /// Callback triggered whenever a UI should be captured from the currently displayed webpage
    ///
    /// - Returns: completion handler to be called once the screenshot has been correctly captured
    public var captureWebpage: ((@escaping (UIImage) -> Void) -> Void)?
    /// Callback triggered whenever the UI has been processed and a rating has been received
    ///
    /// - Parameters:
    ///   - $0: the rating
    ///   - $1: the UI elements relative to the rating
    ///   - $2: the UI screencap
    public var onRating: ((Rating, [UIElement], UIImage?) -> Void)?
    /// Callback triggered whenever an error happens
    ///
    /// - Parameter $0: the error message
    public var onError: ((String) -> Void)?
    
    
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
    ///
    /// - Parameter completion: callback triggered when all operations are completed
    public func confirmInput(_ completion: (() -> Void)?) {
        if let image = uiImage, shouldGatherInput {
            guard additionHistory.flatMap({ $0 }).count >= 2 else {
                completion?()
                self.onError?("Please identify at least two UI elements")
                return
            }
            let request = RatingRequest(items: additionHistory.flatMap({ $0 }),
                                        canvas: Canvas(width: Float(image.size.width), height: Float(image.size.height)))
            NetworkManager().request(request) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let e): self.onError?(e.localizedDescription)
                    case .success(let response): self.onRating?(response, self.additionHistory.flatMap({ $0 }), self.uiImage)
                    }
                    completion?()
                }
            }
        } else {
            captureWebpage?() { [weak self] screencap in
                self?.uiImage = screencap
                self?.shouldGatherInput = true
                DispatchQueue.main.async {
                    completion?()
                    self?.onStartReadingInput?()
                }
            }
        }
    }
    
    /// Saves the given identified UI elements
    ///
    /// - Parameter elements: the user identified UI elements
    public func addElements(_ elements: [UIElement]) {
        additionHistory.append(Set(elements))
        onUpdateUI?(additionHistory.flatMap { $0 })
    }
    
    /// Removes the given element from the list of identified UI elements
    ///
    /// - Parameter element: the element to be removed
    public func removeElement(_ element: UIElement) {
        guard let index = additionHistory.firstIndex(where: { $0.contains(element) }) else { return }
        additionHistory[index].remove(element)
    }
    
    /// Adds an annotation to the given UI element
    ///
    /// - Parameters:
    ///   - element: the UI element to be annotated
    ///   - annotation: the annotation to be added to the UI element
    public func annotate(_ element: UIElement, with annotation: String) {
        guard let index = additionHistory.firstIndex(where: { $0.contains(element) }) else { return }
        var annotatedEl = element
        annotatedEl.annotation = annotation
        additionHistory[index].remove(element)
        additionHistory[index].insert(annotatedEl)
    }
    
    /// Identifies UI elements in the image to be rated using AI
    ///
    /// - Parameter completion: callback triggered once elaboration is completed
    public func startAIProcessing(_ completion: (() -> Void)?) {
        guard let image = uiImage else {
            completion?()
            return
        }
        if let request = ImageProcessingRequest(image: image) {
            NetworkManager().request(request) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let e): self.onError?(e.localizedDescription)
                    case .success(let response):
                        self.additionHistory.append(Set(response))
                        self.onUpdateUI?(self.additionHistory.flatMap({ $0 }))
                    }
                    completion?()
                }
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
        if additionHistory.count > 0 {
            let removed = additionHistory.removeLast()
            onUndo?(removed.count)
        }
        else { dismiss?() }
    }
    
}
