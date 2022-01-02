//
//  InputGatheringViewModel.swift
//  OctoDollop
//
//  Created by alber848 on 02/01/2022.
//

import Foundation


// MARK: - InputGatheringViewModel


class InputGatheringViewModel {
    
    // MARK: - Binding properties
    
    
    /// Callback triggered whenever the whole grading process should be interrupted
    public var dismiss: (() -> Void)?
    
    
    // MARK: - Public methods
    
    
    /// Undoes last action or prompts dismissal if no action can be undone
    public func undo() {
       //TODO: implement
        dismiss?()
    }
}
