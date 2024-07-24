//
//  TVShow.swift
//  Eiga
//
//  Created by Fernando Borrell on 6/26/24.
//

import Foundation
import os.log

struct TVShow: Media, Codable {
    // Media fields
    let adult: Bool?
    let backdropPath: String?
    let genres: [Genre]?
    let id: Int
    let originCountry: [String]?
    let originalLanguage: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let spokenLanguages: [SpokenLanguage]?
    let status: String?
    let title: String?
    
    // Unique fields
    let createdBy: [Creator]?
    let episodeRunTime: [Int]
    let firstAirDate: Date?
    let homepage: String?
    let inProduction: Bool?
    let languages: [String]?
    let lastAirDate: Date?
    let lastEpisodeToAir: Episode?
    let networks: [TVNetwork]?
    let nextEpisodeToAir: Episode?
    let numberOfEpisodes: Int?
    let numberOfSeasons: Int?
    let originalName: String?
    let seasons: [Season]?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case adult, genres, homepage, id, languages, networks, overview, popularity, seasons, status, type
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
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "TVShowDecoding")
        
        func safeDecode<T: Decodable>(_ type: T.Type, forKey key: CodingKeys, defaultValue: T) -> T {
            (try? container.decodeIfPresent(type, forKey: key)) ?? defaultValue
        }
        
        // Set attribute values
        adult = safeDecode(Bool.self, forKey: .adult, defaultValue: false)
        backdropPath = safeDecode(String?.self, forKey: .backdropPath, defaultValue: nil)
        createdBy = safeDecode([Creator].self, forKey: .createdBy, defaultValue: [])
        episodeRunTime = safeDecode([Int].self, forKey: .episodeRunTime, defaultValue: [])
        genres = safeDecode([Genre].self, forKey: .genres, defaultValue: [])
        homepage = safeDecode(String?.self, forKey: .homepage, defaultValue: nil)
        id = safeDecode(Int.self, forKey: .id, defaultValue: 0)
        inProduction = safeDecode(Bool.self, forKey: .inProduction, defaultValue: false)
        languages = safeDecode([String].self, forKey: .languages, defaultValue: [])
        title = safeDecode(String.self, forKey: .title, defaultValue: "Unknown Title")
        networks = safeDecode([TVNetwork].self, forKey: .networks, defaultValue: [])
        numberOfEpisodes = safeDecode(Int.self, forKey: .numberOfEpisodes, defaultValue: 0)
        numberOfSeasons = safeDecode(Int.self, forKey: .numberOfSeasons, defaultValue: 0)
        originCountry = safeDecode([String].self, forKey: .originCountry, defaultValue: [])
        originalLanguage = safeDecode(String.self, forKey: .originalLanguage, defaultValue: "unknown")
        originalName = safeDecode(String.self, forKey: .originalName, defaultValue: "Unknown Original Name")
        overview = safeDecode(String.self, forKey: .overview, defaultValue: "")
        popularity = safeDecode(Double.self, forKey: .popularity, defaultValue: 0.0)
        posterPath = safeDecode(String?.self, forKey: .posterPath, defaultValue: nil)
        productionCompanies = safeDecode([ProductionCompany].self, forKey: .productionCompanies, defaultValue: [])
        productionCountries = safeDecode([ProductionCountry].self, forKey: .productionCountries, defaultValue: [])
        seasons = safeDecode([Season].self, forKey: .seasons, defaultValue: [])
        spokenLanguages = safeDecode([SpokenLanguage].self, forKey: .spokenLanguages, defaultValue: [])
        status = safeDecode(String.self, forKey: .status, defaultValue: "Unknown")
        type = safeDecode(String.self, forKey: .type, defaultValue: "Unknown")
        
        // Convert dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let dateString = safeDecode(String?.self, forKey: .firstAirDate, defaultValue: nil) {
            firstAirDate = dateFormatter.date(from: dateString)
        } else {
            firstAirDate = nil
        }
        
        if let dateString = safeDecode(String?.self, forKey: .lastAirDate, defaultValue: nil) {
            lastAirDate = dateFormatter.date(from: dateString)
        } else {
            lastAirDate = nil
        }
        
        lastEpisodeToAir = try? container.decodeIfPresent(Episode.self, forKey: .lastEpisodeToAir)
        nextEpisodeToAir = try? container.decodeIfPresent(Episode.self, forKey: .nextEpisodeToAir)
        
        // Validate critical issues, to log
        if id == 0 {
            logger.error("Failed to decode TV show ID")
        }
    }
}

struct Creator: Codable, Hashable {
    let id: Int
    let creditId: String
    let name: String
    let originalName: String?
    let gender: Int
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, gender
        case creditId = "credit_id"
        case originalName = "original_name"
        case profilePath = "profile_path"
    }
}

struct Episode: Codable, Hashable {
    let id: Int
    let name: String
    let overview: String
    let airDate: Date?
    let episodeNumber: Int
    let episodeType: String
    let productionCode: String
    let runtime: Int?
    let seasonNumber: Int
    let showId: Int
    let stillPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, overview, runtime
        case airDate = "air_date"
        case episodeNumber = "episode_number"
        case episodeType = "episode_type"
        case productionCode = "production_code"
        case seasonNumber = "season_number"
        case showId = "show_id"
        case stillPath = "still_path"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        overview = try container.decode(String.self, forKey: .overview)
        episodeNumber = try container.decode(Int.self, forKey: .episodeNumber)
        episodeType = try container.decode(String.self, forKey: .episodeType)
        productionCode = try container.decode(String.self, forKey: .productionCode)
        runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
        seasonNumber = try container.decode(Int.self, forKey: .seasonNumber)
        showId = try container.decode(Int.self, forKey: .showId)
        stillPath = try container.decodeIfPresent(String.self, forKey: .stillPath)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let dateString = try container.decodeIfPresent(String.self, forKey: .airDate) {
            airDate = dateFormatter.date(from: dateString)
        } else {
            airDate = nil
        }
    }
}

struct TVNetwork: Codable, Hashable {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}

struct Season: Codable, Hashable {
    let airDate: Date?
    let episodeCount: Int
    let id: Int
    let name: String
    let overview: String
    let posterPath: String?
    let seasonNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, overview
        case airDate = "air_date"
        case episodeCount = "episode_count"
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        overview = try container.decode(String.self, forKey: .overview)
        episodeCount = try container.decode(Int.self, forKey: .episodeCount)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        seasonNumber = try container.decode(Int.self, forKey: .seasonNumber)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let dateString = try container.decodeIfPresent(String.self, forKey: .airDate) {
            airDate = dateFormatter.date(from: dateString)
        } else {
            airDate = nil
        }
    }
}
