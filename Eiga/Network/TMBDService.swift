//
//  TMBDService.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/14/24.
//

/// An actor that provides services for fetching movie and TV show data from TMBD (The Movie Database).
actor TMBDService {
    // MARK: - Dependencies
    
    /// The network manager responsible for making API requests.
    private let networkManager: NetworkManager
    
    // MARK: - Initialization
    
    /// Initializes a new TMBDService instance.
    /// - Parameter networkManager: An optional NetworkManager instance. If not provided, a new one will be created.
    init(networkManager: NetworkManager? = nil) {
        if let networkManager = networkManager {
            self.networkManager = networkManager
        } else {
            self.networkManager = NetworkManager()
        }
    }
    
    // MARK: - Movie Fetching
    
    /// Fetches a specific movie by its ID.
    /// - Parameter id: The unique identifier of the movie.
    /// - Returns: A Media object representing the fetched movie.
    /// - Throws: An error if the network request fails or if the response can't be decoded.
    func fetchMovie(id: Int) async throws -> any Media {
        return try await networkManager.request(from: TMBDEndpoint<Movie>.movie(id: id))
    }
    
    /// Fetches a list of movies currently playing in theaters.
    /// - Returns: An array of Media objects representing the now playing movies.
    /// - Throws: An error if the network request fails or if the response can't be decoded.
    func fetchNowPlayingMovies() async throws -> [any Media] {
        let movieList: MediaList<Movie> = try await networkManager.request(from: TMBDEndpoint<MediaList<Movie>>.nowPlayingMovies)
        return movieList.results
    }
    
    /// Fetches a list of popular movies.
    /// - Returns: An array of Media objects representing popular movies.
    /// - Throws: An error if the network request fails or if the response can't be decoded.
    func fetchPopularMovies() async throws -> [any Media] {
        let movieList: MediaList<Movie> = try await networkManager.request(from: TMBDEndpoint<MediaList<Movie>>.popularMovies)
        return movieList.results
    }
    
    // MARK: - TV Show Fetching
    
    /// Fetches a specific TV show by its ID.
    /// - Parameter id: The unique identifier of the TV show.
    /// - Returns: A Media object representing the fetched TV show.
    /// - Throws: An error if the network request fails or if the response can't be decoded.
    func fetchTVShow(id: Int) async throws -> any Media {
        return try await networkManager.request(from: TMBDEndpoint<TVShow>.tvShow(id: id))
    }
}
