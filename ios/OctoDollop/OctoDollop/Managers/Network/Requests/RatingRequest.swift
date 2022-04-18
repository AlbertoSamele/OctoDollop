//
//  RatingRequest.swift
//  OctoDollop
//
//  Created by alber848 on 17/04/2022.
//

import Foundation


struct RatingRequest: Codable {
    
    /// The elements to be rated
    let items: [UIElement]
    /// The canvas in which the `items` belong to
    let canvas: Canvas
    
}

extension RatingRequest: DataRequest {
    typealias Response = Rating
    
    var endpoint: String { return "rating" }
    var body: Data? { return try? JSONEncoder().encode(self) }
    var headers: [String : String] { return ["Content-Type":"application/json"] }
    var method: HTTPMethod { return .post }
}
