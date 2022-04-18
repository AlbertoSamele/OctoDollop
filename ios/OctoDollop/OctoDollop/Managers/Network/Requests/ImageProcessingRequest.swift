//
//  ImageProcessingRequest.swift
//  OctoDollop
//
//  Created by alber848 on 18/04/2022.
//

import Foundation
import UIKit


struct ImageProcessingRequest {
    /// The image to be elaborated
    private let image: Data
    /// Data request boundary
    private let boundary = UUID().uuidString
    
    init?(image: UIImage) {
        guard let data = image.pngData() else { return nil }
        self.image = data
    }
}

extension ImageProcessingRequest: DataRequest {
    typealias Response = [UIElement]
    
    var endpoint: String { return "ai/bounding_boxes" }
    var body: Data? {
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"image\"; filename=\"image-\(boundary).png\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        return data
    }
    var headers: [String : String] { return ["Content-Type":"multipart/form-data; boundary=\(boundary)"] }
    var method: HTTPMethod { return .post }
}
