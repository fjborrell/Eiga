//
//  Media.swift
//  Eiga
//
//  Created by Fernando Borrell on 6/26/24.
//

import Foundation
import OSLog

protocol Media: Codable, Identifiable, Hashable {
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
    var title: String? { get }
}

struct Genre: Codable, Hashable {
    let id: Int
    let name: String
}

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

struct ProductionCountry: Codable, Hashable {
    let iso31661: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case iso31661 = "iso_3166_1"
        case name
    }
}

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
