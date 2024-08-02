//
//  Color.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/16/24.
//

import Foundation
import SwiftUI

// MARK: - Color Extensions

extension Color {
    /// A custom color 'onyx' representing a very dark gray.
    static let onyx = Color(red: 22/255, green: 22/255, blue: 22/255)
}

// MARK: - LinearGradient Extensions

extension LinearGradient {
    /// A linear gradient for use in tab bars.
    ///
    /// This gradient transitions from a semi-transparent onyx color at the top
    /// to a fully opaque onyx color at 40% of the way down.
    static let tabBar = LinearGradient(
        stops: [
            Gradient.Stop(color: .onyx.opacity(0.80), location: 0.0),
            Gradient.Stop(color: .onyx, location: 0.40) // 40% down
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    /// A linear gradient that transitions from black to onyx.
    ///
    /// This gradient starts with pure black at the top and transitions to onyx,
    /// extending slightly beyond the bottom of the gradient's bounds.
    static let blackOnyxGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .black, location: 0.0),
            Gradient.Stop(color: .onyx, location: 1.15) // location > 1.0 goes beyond its bounds
        ],
        startPoint: .top,
        endPoint: .bottom
    )
}
