//
//  MediaMode.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/16/24.
//

import SwiftUI

/// Represents different modes for filtering media content.
enum MediaMode: String, CaseIterable, Identifiable {
    // MARK: - Cases
    
    case all
    case movie
    case tv
    
    // MARK: - Protocol Conformance
    
    var id: Self { self }
    
    // MARK: - Computed Properties
    
    /// The display title for each media mode.
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
    
    /// The SF Symbol name associated with each media mode.
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
    
    /// The color associated with each media mode.
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
