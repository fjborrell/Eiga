//
//  Movie.swift
//  Eiga
//
//  Created by Fernando Borrell on 6/21/24.

import Foundation

struct Movie: Media {
    let adult: Bool
    let backdropPath: String?
    let budget: Int
    let genres: [Genre]
    let homepage: String
    let id: Int
    let imdbId: String
    let originCountry: [String]
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let releaseDate: String
    let revenue: Int
    let runtime: Int
    let spokenLanguages: [SpokenLanguage]
    let status: String
    let tagline: String
    let title: String
    let video: Bool
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
        case adult, budget, genres, homepage, id, overview, popularity, revenue, runtime, status, tagline, title, video
        case backdropPath = "backdrop_path"
        case imdbId = "imdb_id"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case spokenLanguages = "spoken_languages"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        adult = try container.decodeIfPresent(Bool.self, forKey: .adult) ?? false
        backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        budget = try container.decodeIfPresent(Int.self, forKey: .budget) ?? 0
        genres = try container.decodeIfPresent([Genre].self, forKey: .genres) ?? []
        homepage = try container.decodeIfPresent(String.self, forKey: .homepage) ?? ""
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        imdbId = try container.decodeIfPresent(String.self, forKey: .imdbId) ?? ""
        originCountry = try container.decodeIfPresent([String].self, forKey: .originCountry) ?? []
        originalLanguage = try container.decodeIfPresent(String.self, forKey: .originalLanguage) ?? "en"
        originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle) ?? "Untitled"
        overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? "No overview available"
        popularity = try container.decodeIfPresent(Double.self, forKey: .popularity) ?? 0.0
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        productionCompanies = try container.decodeIfPresent([ProductionCompany].self, forKey: .productionCompanies) ?? []
        productionCountries = try container.decodeIfPresent([ProductionCountry].self, forKey: .productionCountries) ?? []
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate) ?? "TBA"
        revenue = try container.decodeIfPresent(Int.self, forKey: .revenue) ?? 0
        runtime = try container.decodeIfPresent(Int.self, forKey: .runtime) ?? 0
        spokenLanguages = try container.decodeIfPresent([SpokenLanguage].self, forKey: .spokenLanguages) ?? []
        status = try container.decodeIfPresent(String.self, forKey: .status) ?? "Unknown"
        tagline = try container.decodeIfPresent(String.self, forKey: .tagline) ?? ""
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? "Untitled"
        video = try container.decodeIfPresent(Bool.self, forKey: .video) ?? false
        voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage) ?? 0.0
        voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount) ?? 0
    }
}
