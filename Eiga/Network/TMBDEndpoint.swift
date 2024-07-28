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
    case popularMovies
    
    typealias ResponseType = T
    
    var baseURL: String {
        return "https://api.themoviedb.org"
    }
    
    var path: String {
        switch self {
        case .movie(let id):
            return "/3/movie/\(Int32(id))"
        case .tvShow(let id):
            return "/3/tv/\(Int32(id))"
        case .nowPlayingMovies:
            return "/3/movie/now_playing"
        case .popularMovies:
            return "/3/movie/popular"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default:
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
