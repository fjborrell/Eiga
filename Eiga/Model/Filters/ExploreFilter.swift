//
//  MediaMode.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/16/24.
//

/// Represents the filtering options available for exploring `Media` content.
///
/// This enum conforms to `FilterOption` protocol.
enum ExploreFilter: String, FilterOption {
    // MARK: - Cases
    
    /// Filter for popular content
    case popular
    
    /// Filter for the latest content
    case latest
    
    // MARK: - Protocol Conformance
    
    /// The enum case itself as identifier.
    var id: Self { self }
    
    /// A human-readable title for the filter.
    var title: String {
        switch self {
        case .popular:
            return "Popular"
        case .latest:
            return "Latest"
        }
    }
}
