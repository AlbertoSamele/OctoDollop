//
//  NetworkManager+Accessory.swift
//  OctoDollop
//
//  Created by alber848 on 17/04/2022.
//

import Foundation


enum HTTPMethod: String {
    case get = "GET", post = "POST"
}

enum NetworkErrors: Error {
    case invalidCodeRange, invalidEndpoint, missingData
}

protocol DataRequest {
    associatedtype Response
    
    /// The request url endpoint
    var endpoint: String { get }
    /// The HTTP method
    var method: HTTPMethod { get }
    /// The request headers
    var headers: [String:String] { get }
    /// The request parameters
    var queryItems: [String:String] { get }
    /// The request body
    var body: Data? { get }
    
    func decode(_ data: Data) throws -> Response
}

extension DataRequest where Response: Decodable {
    
    func decode(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
    
}

extension DataRequest {
    var headers: [String : String] { return [:] }
    var queryItems: [String:String] { return [:] }
    var body: Data? { return nil }
}
