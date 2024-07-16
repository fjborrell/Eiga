//
//  APIEndpoint.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/14/24.
//

enum Endpoint {
    case movie(id: String)
    case tvShow(id: String)
    
    var path: String {
        switch self {
        case .movie(let id):
            return "/movies\(id)"
        case .tvShow(let id):
            return "/tv/\(id)"
        }
    }
}
