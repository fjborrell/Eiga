//
//  NetworkError.swift
//  Eiga
//
//  Created by Fernando Borrell on 6/28/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case encodingError
    case serverError(statusCode: Int)
    case unknownError(Error)
    
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
