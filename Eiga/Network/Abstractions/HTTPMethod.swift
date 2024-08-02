//
//  HTTPMethod.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/24/24.
//

import Foundation

/// Represents HTTP methods used in network requests.
enum HTTPMethod: String {
    /// GET method: Retrieves a resource.
    case get = "GET"
    
    /// POST method: Submits data to be processed.
    case post = "POST"
    
    /// PUT method: Updates an existing resource.
    case put = "PUT"
    
    /// DELETE method: Removes a specified resource.
    case delete = "DELETE"
}
