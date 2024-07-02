//
//  Media.swift
//  Eiga
//
//  Created by Fernando Borrell on 6/26/24.
//

import Foundation
import OSLog

protocol Media: Codable {
    var adult: Bool? { get }
    var backdropPath: String? { get }
    var genres: [Genre]? { get }
    var id: Int { get }
    var originCountry: [String]? { get }
    var originalLanguage: String? { get }
    var overview: String? { get }
    var popularity: Double? { get }
    var posterPath: String? { get }
    var productionCompanies: [ProductionCompany]? { get }
    var productionCountries: [ProductionCountry]? { get }
    var spokenLanguages: [SpokenLanguage]? { get }
    var status: String? { get }
}

extension Media {
    static func decode<T: Media>(from data: Data) -> Result<T, Error> {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let media = try decoder.decode(T.self, from: data)
            return .success(media)
        } catch {
            Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "MediaDecoding")
                .error("Failed to decode media: \(error.localizedDescription)")
            return .failure(error)
        }
    }
}

struct Genre: Codable {
    let id: Int
    let name: String
}

struct ProductionCompany: Codable {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

struct ProductionCountry: Codable {
    let iso31661: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case iso31661 = "iso_3166_1"
        case name
    }
}

struct SpokenLanguage: Codable {
    let englishName: String
    let iso6391: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso6391 = "iso_639_1"
        case name
    }
}
