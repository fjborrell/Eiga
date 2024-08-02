//
//  MediaList.swift
//  Eiga
//
//  Created by Fernando Borrell on 6/26/24.
//

/// A generic structure representing a list of media items.
struct MediaList<M: Media>: Codable {
    // MARK: - Properties
    
    /// The array of media items.
    let results: [M]
    
    // MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    // MARK: - Initializer
    
    /// Initializes a MediaList instance from a decoder.
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: An error if reading from the decoder fails.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Decode the results array, defaulting to an empty array if not present
        self.results = try container.decodeIfPresent([M].self, forKey: .results) ?? []
    }
}
