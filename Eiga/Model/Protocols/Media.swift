//
//  Media.swift
//  Eiga
//
//  Created by Fernando Borrell on 6/26/24.
//

import Foundation

/// Protocol defining the common properties and methods for media types (e.g., movies, TV shows).
protocol Media: Codable, Identifiable, Hashable, Sendable {
    // MARK: - Common Properties
    
    var adult: Bool { get }
    var backdropPath: String? { get }
    var genres: [Genre] { get }
    var homepage: String { get }
    var id: Int { get }
    var originalLanguage: String { get }
    var overview: String { get }
    var popularity: Double { get }
    var posterPath: String? { get }
    var productionCompanies: [ProductionCompany] { get }
    var productionCountries: [ProductionCountry] { get }
    var spokenLanguages: [SpokenLanguage] { get }
    var status: String { get }
    var tagline: String { get }
    var title: String { get }
    var voteAverage: Double { get }
    var voteCount: Int { get }
    
    // MARK: - Type Alias
    
    /// Type alias for components of media that share common protocol conformances.
    typealias MediaComponent = Codable & Identifiable & Hashable
    
    // MARK: - Image Configuration
    
    var imageConfigurator: TMBDImageConfig { get }
    
    // MARK: - URL Generation Methods
    
    /// Generates the URL for the media's backdrop image.
    /// - Parameter size: The desired size of the image.
    /// - Throws: An error if the backdrop path is missing or empty.
    /// - Returns: A URL for the backdrop image.
    func getBackdropURL<S>(size: S) throws -> URL where S : TMBDImageConfig.ImageSize
    
    /// Generates the URL for the media's poster image.
    /// - Parameter size: The desired size of the image.
    /// - Throws: An error if the poster path is missing or empty.
    /// - Returns: A URL for the poster image.
    func getPosterURL<S>(size: S) throws -> URL where S : TMBDImageConfig.ImageSize
}

// MARK: - Media Components

/// Represents a genre of media.
struct Genre: Codable, Hashable {
    let id: Int
    let name: String
}

/// Represents a production company associated with media.
struct ProductionCompany: Codable, Hashable {
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

/// Represents a production country associated with media.
struct ProductionCountry: Codable, Hashable {
    let iso31661: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case iso31661 = "iso_3166_1"
        case name
    }
}

/// Represents a spoken language in media.
struct SpokenLanguage: Codable, Hashable {
    let englishName: String
    let iso6391: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso6391 = "iso_639_1"
        case name
    }
}
