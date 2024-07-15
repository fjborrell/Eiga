//
//  MediaRepository.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/14/24.
//

actor MediaRepository {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager? = nil) {
        if let networkManager = networkManager {
            self.networkManager = networkManager
        } else {
            self.networkManager = NetworkManager(
                baseURL: "https://api.themoviedb.org/3",
                apiAccessToken: Secrets.API_ACCESS_TOKEN.rawValue
            )
        }
    }
    
    func fetchMovie(id: String) async throws -> Movie {
        let movies: [Movie] = try await networkManager.fetchData(for: .movie(id: id))
        guard let movie = movies.first else {
            throw NetworkError.noData
        }
        return movie
    }
    
    func fetchTVShow(id: String) async throws -> TVShow {
        let shows: [TVShow] = try await networkManager.fetchData(for: .tvShow(id: id))
        guard let show = shows.first else {
            throw NetworkError.noData
        }
        return show
    }
}
