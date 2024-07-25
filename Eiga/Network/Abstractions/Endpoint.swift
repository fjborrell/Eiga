//
//  Endpoint.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/24/24.
//

import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    associatedtype ResponseType: (Decodable & Sendable)
}
