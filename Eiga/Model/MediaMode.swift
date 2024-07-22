//
//  MediaMode.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/16/24.
//

import SwiftUI

enum MediaMode: String, CaseIterable, Identifiable {
    case all
    case movie
    case tv
    
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
    
    var iconName: String {
        switch self {
        case .all:
            return "play.rectangle.on.rectangle.fill"
        case .movie:
            return "film.stack"
        case .tv:
            return "tv"
        }
    }
    
    var color: Color {
        switch self {
        case .all:
            return .pink
        case .movie:
            return .red
        case .tv:
            return .blue
        }
    }
}
