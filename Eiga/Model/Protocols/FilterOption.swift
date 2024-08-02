//
//  Filter.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/21/24.
//

import Foundation

/// Defines the requirements for a filter option in the application.
///
/// This protocol provides a comprehensive set of capabilities for filter options, including identification, iteration,
/// comparison, and hashing.
protocol FilterOption: Identifiable, CaseIterable, Equatable, Hashable {
    /// A human-readable title for the filter option.
    var title: String { get }
}
