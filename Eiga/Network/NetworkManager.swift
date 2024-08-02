//
//  NetworkManager.swift
//  Eiga
//
//  Created by Fernando Borrell on 6/27/24.
//

import Foundation

/// An actor that manages network requests and responses.
actor NetworkManager: Networkable {
    // MARK: - Properties
    
    private let decoder: JSONDecoder
    private let session: URLSession
    
    // MARK: - Initialization
    
    /// Initializes a new NetworkManager instance.
    /// - Parameters:
    ///   - session: The URLSession to use for network requests. Defaults to `.shared`.
    ///   - decoder: The JSONDecoder to use for decoding responses. Defaults to a new instance.
    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    // MARK: - Public Methods
    
    /// Performs a network request based on the provided endpoint.
    /// - Parameter endpoint: The endpoint to request.
    /// - Returns: The decoded response of type `E.ResponseType`.
    /// - Throws: A `NetworkError` if the request fails or the response cannot be decoded.
    func request<E: Endpoint>(from endpoint: E) async throws -> E.ResponseType {
        guard let request = createRequest(from: endpoint) else {
            throw NetworkError.invalidURL
        }
        print("DEBUG: Attempting API Call - \(request.url?.absoluteString ?? "NIL")")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknownError(NSError(domain: "InvalidResponse", code: 0, userInfo: nil))
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        
        print("DEBUG: Successful - \(request.url?.absoluteString ?? "NIL")")
        
        do {
            return try self.decoder.decode(E.ResponseType.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    // MARK: - Private Methods
    
    /// Creates a URLRequest from the given endpoint.
    /// - Parameter endpoint: The endpoint to create the request from.
    /// - Returns: An optional URLRequest.
    private func createRequest(from endpoint: some Endpoint) -> URLRequest? {
        var components = URLComponents(string: endpoint.baseURL)
        components?.path = endpoint.path
        components?.queryItems = endpoint.queryItems
        
        guard let url = components?.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        
        if let body = endpoint.body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        
        return request
    }
}
