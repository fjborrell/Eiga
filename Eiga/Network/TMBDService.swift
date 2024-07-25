//
//  TMBDService.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/14/24.
//

actor TMBDService {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager? = nil) {
        if let networkManager = networkManager {
            self.networkManager = networkManager
        } else {
            self.networkManager = NetworkManager()
        }
    }
    
    func fetchMovie(id: Int) async throws -> Movie {
        return try await networkManager.request(from: TMBDEndpoint<Movie>.movie(id: id))
    }
    
    func fetchTVShow(id: Int) async throws -> TVShow {
        return try await networkManager.request(from: TMBDEndpoint<TVShow>.tvShow(id: id))
    }
    
    func fetchNowPlayingMovies() async throws -> [Movie] {
        return try await networkManager.request(from: TMBDEndpoint<[Movie]>.nowPlayingMovies)
    }
}
