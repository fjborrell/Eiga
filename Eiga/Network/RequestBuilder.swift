//
//  RequestBuilder.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/14/24.
//

import Foundation

class RequestBuilder {
    let baseURL: String
    let apiKey: String
    
    init(baseURL: String, apiKey: String) {
        self.baseURL = baseURL
        self.apiKey = apiKey
    }
    
    func buildRequest(for endpoint: Endpoint, method: String = "GET") -> URLRequest? {
        guard let url = URL(string: baseURL + endpoint.path) else {
            return nil
        }
        
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]

        var request = URLRequest(
            url: url,
            timeoutInterval: 10.0
        )
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        
        return request
    }
}
