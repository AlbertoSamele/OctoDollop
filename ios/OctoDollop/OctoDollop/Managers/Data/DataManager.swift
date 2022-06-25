//
//  DataManager.swift
//  OctoDollop
//
//  Created by alber848 on 18/04/2022.
//

import Foundation
import UIKit


/// Manages interactions with local DB
class DataManager {
    
    // MARK: - Static properties
    
    
    /// Shared manager instance
    public static let shared = DataManager()
    
    
    // MARK: - Private properties
    
    
    /// Userdefaults key to the local database
    private let kPath = "local-db"
    
    
    // MARK: - Inits
    
    
    private init() { }
    
    
    // MARK: - Public methods
    
    
    /// Appends the model to the local DB
    ///
    /// - Parameters:
    ///   - model: the model to save
    ///   - name: the model name
    ///   - image: the image associated to the model
    ///   - completion: returns asyncrhonously, upon completion, whether the saving process was successful or not
    public func add(model: Rating, name: String, image: UIImage?, elements: [UIElement], completion: ((Bool) -> Void)?) {
        do {
            // Retrieving existing models
            var existingRatings = models()
            // Saving new model image
            let imagePath = try save(image: image)
            DispatchQueue.global(qos: .userInitiated).async {
                // Updating new model
                var updatedModel = model
                updatedModel.setName(name)
                updatedModel.setDate(Date())
                updatedModel.setImagePath(imagePath)
                updatedModel.setElements(elements)
                if let mainColor = image?.areaAverage() { updatedModel.setMainColor(mainColor) }
                // Adding new model
                existingRatings.append(updatedModel)
                // Saving updated data
                if let newData = try? JSONEncoder().encode(existingRatings) {
                    UserDefaults.standard.set(newData, forKey: self.kPath)
                    completion?(true)
                } else {
                    completion?(false)
                }
            }
        } catch {
            completion?(false)
        }
    }
    
    /// - Returns: the local db models
    public func models() -> [Rating] {
        var existingRatings: [Rating] = []
        if let existingData = UserDefaults.standard.data(forKey: kPath),
           let decodedData = try? JSONDecoder().decode([Rating].self, from: existingData) {
            existingRatings = decodedData
        }
        return existingRatings
    }
    
    /// - Parameter model: the model whose image is to be known
    /// - Returns: the image for the given model
    public func image(for model: Rating) throws -> UIImage? {
        guard let imagePath = model.imagePath else { throw DataError.invalidModel }
        let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let imageUrl = documentsDirectory.appendingPathComponent(imagePath)
        return UIImage(contentsOfFile: imageUrl.path)
    }
    
    /// Saves the give image to app's document directory
    ///
    /// - Parameter image. the image to be save
    /// - Returns: the filepath of the saved image
    private func save(image: UIImage?) throws -> String? {
        guard let image = image else { return nil }
        let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileName = "rating-\(UUID().uuidString).png"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if let data = image.pngData(), !FileManager.default.fileExists(atPath: fileURL.path) {
            try data.write(to: fileURL)
        } else {
            throw DataError.couldNotSave
        }
        return fileName
    }
}
