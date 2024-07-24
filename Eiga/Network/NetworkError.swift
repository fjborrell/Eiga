//
//  NetworkError.swift
//  Eiga
//
//  Created by Fernando Borrell on 6/28/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL(error: String)
    case unexpectedHTTPResponse(error: String)
    case failedJSONDecoding(error: Error)
    case notFound404
    case noData
    case unauthorized
    case serverError(statusCode: Int)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL(let error):
            return "Invalid URL: \(error)"
        case .unexpectedHTTPResponse(let error):
            return "Unexpected HTTP response: \(error)"
        case .failedJSONDecoding(let error):
            return "Failed to decode JSON: \(error.localizedDescription)"
        case .noData:
            return "No data received from the server"
        case .unauthorized:
            return "Unauthorized access"
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)"
        case .notFound404:
            return "404 - Requested resource not found"
        }
    }
}
