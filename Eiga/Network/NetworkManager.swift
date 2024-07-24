//
//  NetworkManager.swift
//  Eiga
//
//  Created by Fernando Borrell on 6/27/24.
//

import Foundation

actor NetworkManager {
    private let baseURL: String
    private let apiKey: String
    private let requestBuilder: RequestBuilder
    private struct ResultsWrapper<T: Codable>: Codable {
        let results: [T]
    }
    
    init(baseURL: String, apiKey: String) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.requestBuilder = RequestBuilder(baseURL: baseURL, apiKey: apiKey)
    }
    
    
    private func decodeDataToMediaList<T: Media>(data: Data) throws -> [T] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let decodingStrategies: [(String, (Data) throws -> [T])] = [
            ("Results wrapper", {
                return try decoder.decode(ResultsWrapper<T>.self, from: $0).results
            }),
            ("Single object", {
                let decoded = try decoder.decode(T.self, from: $0)
                return [decoded]
            }),
            ("Array", {
                return try decoder.decode([T].self, from: $0)
            })
        ]
        
        for (strategyName, strategy) in decodingStrategies {
            do {
                let result = try strategy(data)
                print("NETWORK_DEBUG - Successfully used \(strategyName) strategy.")
                return result
            } catch {
                print("NETWORK_DEBUG - \(strategyName) strategy failed with error: \(error)")
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .dataCorrupted(let context):
                        print("Data corrupted: \(context.debugDescription)")
                    case .keyNotFound(let key, let context):
                        print("Key '\(key.stringValue)' not found: \(context.debugDescription)")
                    case .typeMismatch(let type, let context):
                        print("Type mismatch for type \(type): \(context.debugDescription)")
                    case .valueNotFound(let type, let context):
                        print("Value of type \(type) not found: \(context.debugDescription)")
                    @unknown default:
                        print("Unknown decoding error: \(decodingError)")
                    }
                }
                continue
            }
        }
        
        print("NETWORK_DEBUG - All decoding strategies failed. Raw JSON data:")
        if let jsonString = String(data: data, encoding: .utf8) {
            print(jsonString)
        } else {
            print("Unable to convert data to string")
        }
        
        throw NetworkError.failedJSONDecoding(error: DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "All decoding strategies failed")))
    }
    
    func fetchData<T: Media>(for endpoint: Endpoint) async throws -> [T] {
        guard let request = requestBuilder.buildRequest(for: endpoint) else {
            throw NetworkError.invalidURL(error: "Failed to build request URL for endpoint: \(endpoint)")
        }
        
        print("NETWORK_DEBUG - Fetching data for endpoint: \(endpoint)")
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unexpectedHTTPResponse(error: "Not an HTTP response")
        }
        
        print("NETWORK_DEBUG - Received response with status code: \(httpResponse.statusCode)")
        switch httpResponse.statusCode {
        case 200...299:
            let decodedData = try decodeDataToMediaList(data: data) as [T]
            print("NETWORK_DEBUG - Successfully decoded \(decodedData.count) items.")
            return decodedData
        case 401:
            throw NetworkError.unauthorized
        case 404:
            throw NetworkError.notFound404
        case 500...599:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        default:
            throw NetworkError.unexpectedHTTPResponse(error: "Status code: \(httpResponse.statusCode)")
        }
    }
}
