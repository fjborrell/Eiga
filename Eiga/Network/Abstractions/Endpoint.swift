//
//  Endpoint.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/24/24.
//

import Foundation

/// A protocol that defines the structure for network endpoints.
///
/// This protocol provides a standardized way to configure and represent
/// API endpoints, including URL components, HTTP method, headers, and response type.
protocol Endpoint {
    // MARK: - URL Components
    
    /// The base URL for the API.
    var baseURL: String { get }
    
    /// The specific path for this endpoint.
    var path: String { get }
    
    /// Optional query items to be appended to the URL.
    var queryItems: [URLQueryItem]? { get }
    
    // MARK: - HTTP Configuration
    
    /// The HTTP method to be used for this endpoint.
    var method: HTTPMethod { get }
    
    /// Optional headers to be included in the request.
    var header: [String: String]? { get }
    
    /// Optional body parameters for the request.
    var body: [String: String]? { get }
    
    // MARK: - Response Type
    
    /// The associated type representing the expected response model.
    ///
    /// This type must conform to both `Decodable` for JSON parsing
    /// and `Sendable` for concurrency safety.
    associatedtype ResponseType: (Decodable & Sendable)
}
