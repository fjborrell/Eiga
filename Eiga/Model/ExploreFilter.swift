//
//  MediaMode.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/16/24.
//

enum ExploreFilter: String, CaseIterable, Identifiable {
    case popular
    case latest
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .popular:
            return "Popular"
        case .latest:
            return "Latest"
        }
    }
}
