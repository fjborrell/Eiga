//
//  Tab.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/18/24.
//

import Foundation

/// Represents the main tabs in the app's navigation structure.
enum Tab: Int, Equatable, Identifiable, CaseIterable {
    // MARK: - Cases
    
    case explore = 0
    case library
    case crews
    case profile
    
    // MARK: - Protoocl Conformance
    
    var id: Self { self }
    
    // MARK: - Computed Properties
    
    /// The display title for each tab.
    var title: String {
        switch self {
        case .explore:
            return "Explore"
        case .library:
            return "Library"
        case .crews:
            return "Crews"
        case .profile:
            return "Me"
        }
    }
    
    /// The SF Symbol name associated with each tab.
    var iconName: String {
        switch self {
        case .explore:
            return "bubbles.and.sparkles.fill"
        case .library:
            return "book.pages.fill"
        case .crews:
            return "figure.2.right.holdinghands"
        case .profile:
            return "person.fill"
        }
    }
}
