//
//  Movie.swift
//  Eiga
//
//  Created by Fernando Borrell on 6/21/24.

import Foundation
import OSLog

struct Movie: Media, Codable {
    // Media fields
    var adult: Bool?
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
    
    // Unique fields
    let belongsToCollection: MovieCollection?
    let budget: Int?
    let imdbID: String?
    let originalTitle: String?
    let releaseDate: Date?
    let revenue: Int?
    let runtime: Int?
    let title: String?
    let video: Bool?
    
    enum CodingKeys: String, CodingKey {
        case adult, budget, genres, id, overview, popularity, revenue, runtime, status, title, video
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case imdbID = "imdb_id"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case spokenLanguages = "spoken_languages"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "MovieDecoding")
        
        func safeDecode<T: Decodable>(_ type: T.Type, forKey key: CodingKeys, defaultValue: T) -> T {
            (try? container.decodeIfPresent(type, forKey: key)) ?? defaultValue
        }
        
        // Set attribute values
        adult = safeDecode(Bool.self, forKey: .adult, defaultValue: false)
        backdropPath = safeDecode(String?.self, forKey: .backdropPath, defaultValue: nil)
        belongsToCollection = try? container.decodeIfPresent(MovieCollection.self, forKey: .belongsToCollection)
        budget = safeDecode(Int.self, forKey: .budget, defaultValue: 0)
        genres = safeDecode([Genre].self, forKey: .genres, defaultValue: [])
        id = safeDecode(Int.self, forKey: .id, defaultValue: 0)
        imdbID = safeDecode(String?.self, forKey: .imdbID, defaultValue: nil)
        originCountry = safeDecode([String].self, forKey: .originCountry, defaultValue: [])
        originalLanguage = safeDecode(String.self, forKey: .originalLanguage, defaultValue: "unknown")
        originalTitle = safeDecode(String.self, forKey: .originalTitle, defaultValue: "Unknown Title")
        overview = safeDecode(String.self, forKey: .overview, defaultValue: "")
        popularity = safeDecode(Double.self, forKey: .popularity, defaultValue: 0.0)
        posterPath = safeDecode(String?.self, forKey: .posterPath, defaultValue: nil)
        productionCompanies = safeDecode([ProductionCompany].self, forKey: .productionCompanies, defaultValue: [])
        productionCountries = safeDecode([ProductionCountry].self, forKey: .productionCountries, defaultValue: [])
        
        // Convert date to Date() type
        if let dateString = safeDecode(String?.self, forKey: .releaseDate, defaultValue: nil) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            releaseDate = dateFormatter.date(from: dateString)
        } else {
            releaseDate = nil
        }
        
        revenue = safeDecode(Int.self, forKey: .revenue, defaultValue: 0)
        runtime = safeDecode(Int?.self, forKey: .runtime, defaultValue: nil)
        spokenLanguages = safeDecode([SpokenLanguage].self, forKey: .spokenLanguages, defaultValue: [])
        status = safeDecode(String.self, forKey: .status, defaultValue: "Unknown")
        title = safeDecode(String.self, forKey: .title, defaultValue: "Unknown Title")
        video = safeDecode(Bool.self, forKey: .video, defaultValue: false)
        
        // Validate critical issues, to log
        if id == 0 {
            logger.error("Failed to decode movie ID")
        }
    }
}

struct MovieCollection: Codable {
    let id: Int
    let name: String
    let posterPath: String?
    let backdropPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}
