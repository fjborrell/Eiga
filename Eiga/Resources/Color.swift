//
//  Color.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/16/24.
//

import Foundation
import SwiftUI

extension Color {
    static let onyx = Color(red: 22/255, green: 22/255, blue: 22/255)
    static let darkGrey = Color(red: 4/255, green: 4/255, blue: 4/255)
}

extension LinearGradient {
    static let tabBar = LinearGradient(
        stops: [
            Gradient.Stop(color: .onyx.opacity(0.80), location: 0.0),
            Gradient.Stop(color: .onyx, location: 0.40)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let blackOnyxGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .black, location: 0.0),
            Gradient.Stop(color: .onyx, location: 1.15)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
}
