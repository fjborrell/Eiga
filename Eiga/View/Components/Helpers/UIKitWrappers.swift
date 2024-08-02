//
//  UIKitWrappers.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/31/24.
//

import UIKit
import SwiftUI

/// A custom view that applies a blur effect to its background.
struct CustomBlurView: UIViewRepresentable {
    // MARK: - Properties
    
    /// The style of the blur effect to be applied.
    let style: UIBlurEffect.Style
    
    // MARK: -  Methods
    
    /// Creates and returns a `UIVisualEffectView` with the specified blur effect.
    /// - Parameter context: The context in which the view is created.
    /// - Returns: A `UIVisualEffectView` with the applied blur effect.
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    /// Updates the view if needed. In this case, no update is necessary.
    /// - Parameters:
    ///   - uiView: The view to update.
    ///   - context: The context in which the view is updated.
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        // No update needed
    }
}
