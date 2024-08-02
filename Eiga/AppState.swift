//
//  AppState.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/21/24.
//

import Foundation

/// An observable representation of the application's state
@Observable
class AppState {
    /// The currently selected media mode for content exploration
    var selectedMediaMode: MediaMode = .all
}

