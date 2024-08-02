//
//  Networkable.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/24/24.
//

import Foundation

/// A protocol defining an actor capable of making network requests.
///
/// This protocol is designed to be implemented by actors that handle network communication.
/// It provides a generic method for making requests to endpoints and receiving typed responses.
protocol Networkable: Actor {
    /// Performs a network request to the specified endpoint and returns the response.
    ///
    /// This method is generic, allowing it to work with any type conforming to the `Endpoint` protocol.
    /// The response type is determined by the `Endpoint`'s associated `ResponseType`.
    ///
    /// - Parameter endpoint: The endpoint to which the request will be made.
    /// - Returns: The response from the endpoint, of type `E.ResponseType`.
    /// - Throws: Any error that might occur during the network request or response handling.
    func request<E: Endpoint>(from endpoint: E) async throws -> E.ResponseType
}
