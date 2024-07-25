//
//  TMBDEndpoint.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/14/24.
//
import Foundation

enum TMBDEndpoint<T: Decodable & Sendable>: Endpoint {
    case movie(id: Int)
    case tvShow(id: Int)
    case nowPlayingMovies
    
    typealias ResponseType = T
    
    var baseURL: String {
        return "https://api.themoviedb.org/3"
    }
    
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
    
    var method: HTTPMethod {
        switch self {
        case .movie(_), .tvShow(_), .nowPlayingMovies:
            return .get
        }
    }
    
    var header: [String : String]? {
        return [
            "accept": "application/json",
            "Authorization": "Bearer \(Secrets.API_KEY.rawValue)"
        ]
    }
    
    var body: [String : String]? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
}
