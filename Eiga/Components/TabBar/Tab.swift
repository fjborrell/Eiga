//
//  Tab.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/18/24.
//

import Foundation

enum Tab: Int, Equatable, Identifiable, CaseIterable {
    var id: Self {
        return self
    }
    
    case explore = 0
    case library
    case crews
    case profile
    
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
