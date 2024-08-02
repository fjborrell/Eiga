//
//  TMBDEndpoint.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/14/24.
//

import Foundation

/// Represents various endpoints for The Movie Database (TMDB) API.
/// Each case corresponds to a specific API request type.
enum TMBDEndpoint<T: Decodable & Sendable>: Endpoint {
    // MARK: - Endpoint Cases
    
    /// Fetches details for a specific movie.
    case movie(id: Int)
    
    /// Fetches details for a specific TV show.
    case tvShow(id: Int)
    
    /// Fetches the list of movies currently playing in theaters.
    case nowPlayingMovies
    
    /// Fetches the list of popular movies.
    case popularMovies
    
    // MARK: - Endpoint Protocol Requirements
    
    /// The type of the expected response from the API.
    typealias ResponseType = T
    
    /// The base URL for all TMDB API requests.
    var baseURL: String {
        return "https://api.themoviedb.org"
    }
    
    /// The specific path for each endpoint, appended to the base URL.
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
    
    /// The HTTP method used for the request.
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    /// The headers required for the API request.
    var header: [String : String]? {
        return [
            "accept": "application/json",
            "Authorization": "Bearer \(Secrets.API_KEY.rawValue)"
        ]
    }
    
    /// The body of the request.
    var body: [String : String]? {
        return nil
    }
    
    /// Query items for the request.
    var queryItems: [URLQueryItem]? {
        return nil
    }
}
