//
//  Networkable.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/24/24.
//

import Foundation

protocol Networkable: Actor {
    func request<E: Endpoint>(from endpoint: E) async throws -> E.ResponseType
}
