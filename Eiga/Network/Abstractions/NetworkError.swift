//
//  NetworkError.swift
//  Eiga
//
//  Created by Fernando Borrell on 6/28/24.
//

import Foundation

/// Represents various network-related errors that can occur during API operations.
enum NetworkError: Error {
    // MARK: Error Cases
    
    /// The URL provided for the network request is invalid.
    case invalidURL
    
    /// No data was received from the network request.
    case noData
    
    /// An error occurred while decoding the received data.
    case decodingError
    
    /// An error occurred while encoding data for the request.
    case encodingError
    
    /// The server responded with an error status code.
    case serverError(statusCode: Int)
    
    /// An unknown error occurred during the network operation.
    case unknownError(Error)
    
    // MARK: Computed Properties
    
    /// A human-readable description of the error.
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data was found"
        case .decodingError:
            return "Error decoding"
        case .encodingError:
            return "Error encoding"
        case .serverError(let statusCode):
            return "Server Error: \(statusCode)"
        case .unknownError(let error):
            return "Unknown Error: \(error)"
        }
    }
}
