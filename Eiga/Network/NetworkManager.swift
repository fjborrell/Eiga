//
//  NetworkManager.swift
//  Eiga
//
//  Created by Fernando Borrell on 6/27/24.
//

import Foundation

actor NetworkManager {
    
    private let baseURL: String
    private let apiAccessToken: String
    private let requestBuilder: RequestBuilder
    private struct ResultsWrapper<T: Codable>: Codable {
        let results: [T]
    }
    
    init(baseURL: String, apiAccessToken: String) {
        self.baseURL = baseURL
        self.apiAccessToken = apiAccessToken
        self.requestBuilder = RequestBuilder(baseURL: baseURL, apiAccessToken: apiAccessToken)
    }
    
    
    // Return list of decoded Media types
    private func decodeDataToMediaList<T: Media>(data: Data) throws -> [T] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // Lambda defined decoding strategies as such:
        /// STRATEGY: { try decoder.decode(AnotherWrapper<T>.self, from: $0).data }
        /// WRAPPER: struct AnotherWrapper<T: Codable>: Codable { let data: [T] }
        let decodingStrategies: [(Data) throws -> [T]] = [
            { try [decoder.decode(T.self, from: $0)] },     // Single Media object
            { try decoder.decode([T].self, from: $0) },     // List of Media objects
            { try decoder.decode(ResultsWrapper<T>.self, from: $0).results },   // List of media objects
        ]
        
        for strategy in decodingStrategies {
            do {
                return try strategy(data)
            } catch {
                continue
            }
        }
        
        throw NetworkError.failedJSONDecoding(error: DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "All decoding strategies failed")))
    }
    
    func fetchData<T: Media>(for endpoint: Endpoint) async throws -> [T] {
        guard let request = requestBuilder.buildRequest(for: endpoint) else {
            throw NetworkError.invalidURL(error: "Failed to build request URL for endpoint: \(endpoint)")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Validate HTTP response code
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unexpectedHTTPResponse(error: "Not an HTTP response")
        }
        
        switch httpResponse.statusCode {
        case 200...299:     // Success Case
            return try decodeDataToMediaList(data: data)
        case 401:
            throw NetworkError.unauthorized
        case 500...599:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        default:
            throw NetworkError.unexpectedHTTPResponse(error: "Status code: \(httpResponse.statusCode)")
        }
    }
}
