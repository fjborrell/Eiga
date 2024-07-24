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
                apiKey: Secrets.API_KEY.rawValue
            )
        }
    }
    
    func fetchMovie(id: Int) async throws -> Movie {
        let movies: [Movie] = try await networkManager.fetchData(for: .movie(id: id))
        guard let movie = movies.first else {
            throw NetworkError.noData
        }
        return movie
    }
    
    func fetchTVShow(id: Int) async throws -> TVShow {
        let shows: [TVShow] = try await networkManager.fetchData(for: .tvShow(id: id))
        guard let show = shows.first else {
            throw NetworkError.noData
        }
        return show
    }
    
    func fetchNowPlayingMovies() async throws -> [Movie] {
        let movies: [Movie]? = try await networkManager.fetchData(for: .nowPlayingMovies)
        guard let movies = movies else {
            throw NetworkError.noData
        }
        return movies
    }
}
