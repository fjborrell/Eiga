//
//  TVShow.swift
//  Eiga
//
//  Created by Fernando Borrell on 6/26/24.
//

import Foundation

struct TVShow: Media {
    let adult: Bool
    let backdropPath: String?
    let createdBy: [Creator]
    let episodeRunTime: [Int]
    let firstAirDate: String
    let genres: [Genre]
    let homepage: String
    let id: Int
    let inProduction: Bool
    let languages: [String]
    let lastAirDate: String
    let lastEpisodeToAir: Episode?
    let nextEpisodeToAir: Episode?
    let networks: [Network]
    let numberOfEpisodes: Int
    let numberOfSeasons: Int
    let originCountry: [String]
    let originalLanguage: String
    let originalName: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let seasons: [Season]
    let spokenLanguages: [SpokenLanguage]
    let status: String
    let tagline: String
    let title: String
    let type: String
    let voteAverage: Double
    let voteCount: Int
    
    var imageConfigurator: TMBDImageConfig = TMBDImageConfig()
    
    func getBackdropURL<S>(size: S) throws -> URL where S : TMBDImageConfig.ImageSize {
        guard let backdropPath = self.backdropPath, !backdropPath.isEmpty else {
            throw ImageError.missingImagePath
        }
        return imageConfigurator.buildURL(path: backdropPath, size: size)
    }
    
    func getPosterURL<S>(size: S) throws -> URL where S : TMBDImageConfig.ImageSize {
        guard let posterPath = self.posterPath, !posterPath.isEmpty else {
            throw ImageError.missingImagePath
        }
        return imageConfigurator.buildURL(path: posterPath, size: size)
    }

    enum CodingKeys: String, CodingKey {
        case adult, genres, homepage, id, languages, networks, overview, popularity, seasons, status, tagline, type
        case backdropPath = "backdrop_path"
        case createdBy = "created_by"
        case episodeRunTime = "episode_run_time"
        case firstAirDate = "first_air_date"
        case inProduction = "in_production"
        case lastAirDate = "last_air_date"
        case lastEpisodeToAir = "last_episode_to_air"
        case nextEpisodeToAir = "next_episode_to_air"
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case spokenLanguages = "spoken_languages"
        case title = "name"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        adult = try container.decodeIfPresent(Bool.self, forKey: .adult) ?? false
        backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath) ?? ""
        createdBy = try container.decodeIfPresent([Creator].self, forKey: .createdBy) ?? []
        episodeRunTime = try container.decodeIfPresent([Int].self, forKey: .episodeRunTime) ?? []
        firstAirDate = try container.decodeIfPresent(String.self, forKey: .firstAirDate) ?? "TBA"
        genres = try container.decodeIfPresent([Genre].self, forKey: .genres) ?? []
        homepage = try container.decodeIfPresent(String.self, forKey: .homepage) ?? ""
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        inProduction = try container.decodeIfPresent(Bool.self, forKey: .inProduction) ?? false
        languages = try container.decodeIfPresent([String].self, forKey: .languages) ?? []
        lastAirDate = try container.decodeIfPresent(String.self, forKey: .lastAirDate) ?? "N/A"
        lastEpisodeToAir = try container.decodeIfPresent(Episode.self, forKey: .lastEpisodeToAir)
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? "Untitled Series"
        nextEpisodeToAir = try container.decodeIfPresent(Episode.self, forKey: .nextEpisodeToAir)
        networks = try container.decodeIfPresent([Network].self, forKey: .networks) ?? []
        numberOfEpisodes = try container.decodeIfPresent(Int.self, forKey: .numberOfEpisodes) ?? 0
        numberOfSeasons = try container.decodeIfPresent(Int.self, forKey: .numberOfSeasons) ?? 0
        originCountry = try container.decodeIfPresent([String].self, forKey: .originCountry) ?? []
        originalLanguage = try container.decodeIfPresent(String.self, forKey: .originalLanguage) ?? "en"
        originalName = try container.decodeIfPresent(String.self, forKey: .originalName) ?? "Untitled Series"
        overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? "No overview available"
        popularity = try container.decodeIfPresent(Double.self, forKey: .popularity) ?? 0.0
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath) ?? ""
        productionCompanies = try container.decodeIfPresent([ProductionCompany].self, forKey: .productionCompanies) ?? []
        productionCountries = try container.decodeIfPresent([ProductionCountry].self, forKey: .productionCountries) ?? []
        seasons = try container.decodeIfPresent([Season].self, forKey: .seasons) ?? []
        spokenLanguages = try container.decodeIfPresent([SpokenLanguage].self, forKey: .spokenLanguages) ?? []
        status = try container.decodeIfPresent(String.self, forKey: .status) ?? "Unknown"
        tagline = try container.decodeIfPresent(String.self, forKey: .tagline) ?? ""
        type = try container.decodeIfPresent(String.self, forKey: .type) ?? "TV Series"
        voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage) ?? 0.0
        voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount) ?? 0
    }
}

extension TVShow {
    struct Creator: MediaComponent {
        let id: Int
        let creditId: String
        let name: String
        let gender: Int
        let profilePath: String?

        enum CodingKeys: String, CodingKey {
            case id, name, gender
            case creditId = "credit_id"
            case profilePath = "profile_path"
        }
    }

    struct Episode: MediaComponent {
        let id: Int
        let name: String
        let overview: String
        let voteAverage: Double
        let voteCount: Int
        let airDate: String
        let episodeNumber: Int
        let episodeType: String
        let productionCode: String
        let runtime: Int
        let seasonNumber: Int
        let showId: Int
        let stillPath: String?

        enum CodingKeys: String, CodingKey {
            case id, name, overview, runtime
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
            case airDate = "air_date"
            case episodeNumber = "episode_number"
            case episodeType = "episode_type"
            case productionCode = "production_code"
            case seasonNumber = "season_number"
            case showId = "show_id"
            case stillPath = "still_path"
        }
    }

    struct Network: MediaComponent {
        let id: Int
        let name: String
        let logoPath: String?
        let originCountry: String

        enum CodingKeys: String, CodingKey {
            case id, name
            case logoPath = "logo_path"
            case originCountry = "origin_country"
        }
    }

    struct Season: MediaComponent {
        let airDate: String
        let episodeCount: Int
        let id: Int
        let name: String
        let overview: String
        let posterPath: String?
        let seasonNumber: Int
        let voteAverage: Double

        enum CodingKeys: String, CodingKey {
            case id, name, overview
            case airDate = "air_date"
            case episodeCount = "episode_count"
            case posterPath = "poster_path"
            case seasonNumber = "season_number"
            case voteAverage = "vote_average"
        }
    }
}
