//
//  APIClient.swift
//  Hacker News Example
//
//  Created by Marcio Duarte on 10/22/20.
//

import Foundation

/// An abstract APIClient for `HNResponse`s
protocol APIClient {
    func fetchPosts(handler: @escaping ((Result<HNResponse, AppError>) -> Void))
}

/// A particular implementation for algolia
class APIClientImpl: APIClient {
    private var baseURL: String
    
    /// Create the client using a base URL
    required init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    /// Fetch the lastests posts from the API Endpoint
    func fetchPosts(handler: @escaping ((Result<HNResponse, AppError>) -> Void)) {
        guard var endpoint = URLComponents(string: baseURL) else {
            handler(.failure(.invalidBaseURL))
            return
        }
        
        // construct the endpoint URL
        endpoint.path = "/api/v1/search_by_date"
        endpoint.queryItems = [
            URLQueryItem(name: "query", value: "ios"),
            URLQueryItem(name: "tags", value: "story")
        ]
        
        guard let url = endpoint.url else {
            handler(.failure(.invalidEndpoindURL))
            return
        }
        
        // perform the request
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                //according to apple's documentation if data == nil then error != nil
                handler(.failure(.networkError(cause: error!)))
                return
            }
            
            do {
                // parse the response
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601withFractionalSeconds // using custom formatter to parse iso8601 fractional seconds
                
                // decode the json response
                let hnResponse = try decoder.decode(HNResponse.self, from: data)
                handler(.success(hnResponse))
            } catch let error {
                handler(.failure(.decodingError(cause: error)))
            }
        }.resume()
    }
}
