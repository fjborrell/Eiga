//
//  MediaMode.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/16/24.
//

enum MediaMode: String, CaseIterable, Identifiable {
    case tv
    case movie
    case all
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .all:
            return "All"
        case .movie:
            return "Movie"
        case .tv:
            return "TV"
        }
    }
}