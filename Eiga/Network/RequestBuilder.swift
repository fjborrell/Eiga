//
//  RequestBuilder.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/14/24.
//

import Foundation

class RequestBuilder {
    let baseURL: String
    let apiAccessToken: String
    
    init(baseURL: String, apiAccessToken: String) {
        self.baseURL = baseURL
        self.apiAccessToken = apiAccessToken
    }
    
    func buildRequest(for endpoint: Endpoint, method: String = "GET") -> URLRequest? {
        guard let url = URL(string: baseURL + endpoint.path) else {
            return nil
        }
        
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer \(apiAccessToken)"
        ]

        var request = URLRequest(
            url: url,
            cachePolicy: .reloadRevalidatingCacheData,
            timeoutInterval: 10.0
        )
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        
        return request
    }
}
