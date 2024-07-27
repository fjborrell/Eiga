//
//  MediaList.swift
//  Eiga
//
//  Created by Fernando Borrell on 6/26/24.
//

struct MediaList<M: Media>: Codable {
    let results: [M]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.results = try container.decodeIfPresent([M].self, forKey: .results) ?? []
    }
}
