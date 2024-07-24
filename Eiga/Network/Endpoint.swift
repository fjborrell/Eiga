//
//  APIEndpoint.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/14/24.
//

enum Endpoint {
    case movie(id: Int)
    case tvShow(id: Int)
    case nowPlayingMovies
    
    var path: String {
        switch self {
        case .movie(let id):
            return "/movie/\(Int32(id))"
        case .tvShow(let id):
            return "/tv/\(Int32(id))"
        case .nowPlayingMovies:
            return "/movie/now_playing"
        }
    }
}
