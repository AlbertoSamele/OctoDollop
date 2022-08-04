//
//  NetworkManager.swift
//  OctoDollop
//
//  Created by alber848 on 17/04/2022.
//

import Foundation


class NetworkManager {
    
    // MARK: - Private properties
    
    
    /// Octodollop API base url
    private let baseUrl = "https://d2e3-44-204-233-16.ngrok.io/"
    
    
    // MARK: - Private methods
    
    
    public func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) {
        let endpointUrl = baseUrl + request.endpoint
        guard var urlComponent = URLComponents(string: endpointUrl) else {
            return completion(.failure(NetworkErrors.invalidEndpoint))
        }
        // Updating query items
        var queryItems: [URLQueryItem] = []
        request.queryItems.forEach {
            let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
            queryItems.append(urlQueryItem)
        }
        if queryItems.count > 0 { urlComponent.queryItems = queryItems }
        // Updating headers
        guard let url = urlComponent.url else { return completion(.failure(NetworkErrors.invalidEndpoint)) }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        if let body = request.body { urlRequest.httpBody = body }
        // Launching the request
        URLSession(configuration: .default).dataTask(with: urlRequest) { data, response, error in
            // Handling explicit errors
            if let error = error { return completion(.failure(error)) }
            // Handling invalid status codes
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                return completion(.failure(NetworkErrors.invalidCodeRange))
            }
            // Handling missing response data
            guard let data = data else { return completion(.failure(NetworkErrors.missingData)) }
            // Attempting response decoding
            do {
                try completion(.success(request.decode(data)))
            } catch let error as NSError {
                completion(.failure(error))
            }
        }
        .resume()
    }
}
