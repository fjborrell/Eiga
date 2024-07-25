//
//  NetworkManager.swift
//  Eiga
//
//  Created by Fernando Borrell on 6/27/24.
//

import Foundation

actor NetworkManager: Networkable {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func request<E: Endpoint>(from endpoint: E) async throws -> E.ResponseType {
        guard let request = createRequest(from: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknownError(NSError(domain: "InvalidResponse", code: 0, userInfo: nil))
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        
        do {
            return try self.decoder.decode(E.ResponseType.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
    
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
