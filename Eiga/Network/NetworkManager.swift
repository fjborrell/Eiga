//
//  NetworkManager.swift
//  Eiga
//
//  Created by Fernando Borrell on 6/27/24.
//

import Foundation

class NetworkManager {
    @MainActor static let shared: NetworkManager = NetworkManager()
    private let apiAccessToken: String = Secrets.API_ACCESS_TOKEN.rawValue

    private init() {}

    private func GETRequest<T: Decodable>(apiRequestUrl: String, decodeTargetClass: T.Type) async throws -> T {

        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer \(apiAccessToken)"
        ]

        guard let url = URL(string: apiRequestUrl) else {
            throw NetworkError.invalidURL(error: "Failed API request: Invalid URL")
        }

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        // Execute request asynchronously
        let (data, response) = try await URLSession.shared.data(for: request)

        // Validate HTTP response, and check it is successful (200-299)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.unexpectedHTTPResponse(error: String(describing: response))
        }

        // Attempt to decode data from JSON
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch {
            throw NetworkError.failedJSONDecoding(error: error)
        }
    }

    func fetchConfiguration() async throws -> Configuration {
        do {
            return try await GETRequest(
                apiRequestUrl: "https://api.themoviedb.org/3/configuration",
                decodeTargetClass: Configuration.self
            )
        } catch {
            throw NetworkError.APIRequestError(nestedError: error)
        }
    }

    func fetchNewAndPopular() async throws -> [Movie] {
        let requestURL = """
        https://api.themoviedb.org/3/discover/movie\
        ?include_adult=false\
        &include_video=false\
        &language=en-US\
        &page=1\
        &primary_release_date.gte=\(threeMonthsAgo)\
        &primary_release_date.lte=\(today)\
        &sort_by=popularity.desc\
        &with_original_language=en
        """

        do {
            let result = try await GETRequest(
                apiRequestUrl: requestURL,
                decodeTargetClass: BulkMediaQuery.self
            )
            return result.mediaList
        } catch {
            throw NetworkError.APIRequestError(nestedError: error)
        }
    }

    // Fetch list of upcoming movies (Release date in <3 months)
    func fetchUpcoming() async throws -> [Movie] {
        let requestURL = """
        https://api.themoviedb.org/3/discover/movie\
        ?include_adult=false\
        &include_video=false\
        &language=en-US\
        &page=1\
        &primary_release_date.gte=\(today)\
        &primary_release_date.lte=\(threeMonthsFromNow)\
        &sort_by=popularity.desc\
        &with_original_language=en
        """

        do {
            let result = try await GETRequest(
                apiRequestUrl: requestURL,
                decodeTargetClass: BulkMediaQuery.self
            )
            return result.mediaList
        } catch {
            throw NetworkError.APIRequestError(nestedError: error)
        }
    }

    // Fetch featured movies (Vote count >= 100, Vote Avg >= 7, Released in last month)
    func fetchFeatured() async throws -> [Movie] {
        let requestURL = """
        https://api.themoviedb.org/3/discover/movie\
        ?include_adult=false\
        &include_video=false\
        &language=en-US&page=1\
        &primary_release_date.gte=\(oneMonthAgo)\
        &sort_by=vote_count.desc\
        &vote_average.gte=7\
        &vote_count.gte=100\
        &with_original_language=en
        """

        do {
            let result = try await GETRequest(
                apiRequestUrl: requestURL,
                decodeTargetClass: BulkMediaQuery.self
            )
            return result.mediaList
        } catch {
            throw NetworkError.APIRequestError(nestedError: error)
        }
    }

    // Fetch list of movies that match search query
    func searchMovie(keyword: String) async throws -> [Movie] {
        let requestURL = """
        https://api.themoviedb.org/3/search/movie\
        ?query=\(keyword)\
        &include_adult=false\
        &language=en-US\
        &page=1
        """

        do {
            let result = try await GETRequest(
                apiRequestUrl: requestURL,
                decodeTargetClass: BulkMediaQuery.self
            )
            return result.mediaList
        } catch {
            throw NetworkError.APIRequestError(nestedError: error)
        }
    }

    // Fetch list of TV shows that match search query
    func searchTV(keyword: String) async throws -> [Movie] {
        let requestURL = """
        https://api.themoviedb.org/3/search/tv\
        ?query=\(keyword)\
        &include_adult=false\
        &language=en-US\
        &page=1
        """

        do {
            let result = try await GETRequest(
                apiRequestUrl: requestURL,
                decodeTargetClass: BulkMediaQuery.self
            )
            return result.mediaList
        } catch {
            throw NetworkError.APIRequestError(nestedError: error)
        }
    }
}
