//
//  RoundedBlurBackgroundView.swift
//  Eiga
//
//  Created by Fernando Borrell on 8/2/24.
//

import SwiftUI
import UIKit

// MARK: - View Modifiers

/// A view modifier that applies a rounded, blurred background to its content.
struct RoundedBlurBackground: ViewModifier {
    // MARK: Properties
    
    /// The style of the blur effect to be applied.
    let style: UIBlurEffect.Style
    
    /// The padding between the content and background.
    let padding: CGFloat
    
    /// The opacity of the blur effect.
    let opacity: CGFloat
    
    /// The corner radius of the rounded rectangle.
    let radius: CGFloat
    
    // MARK: Body
    
    /// Applies the rounded blur background to the content.
    /// - Parameter content: The content to which the background will be applied.
    /// - Returns: A view with the content wrapped in a rounded, blurred background.
    func body(content: Content) -> some View {
        ZStack(alignment: .center) {
            content
                .padding(self.padding)
                .background {
                    CustomBlurView(style: self.style)
                        .clipShape(
                            RoundedRectangle(cornerRadius: radius)
                        )
                        .opacity(self.opacity)
                }
        }
    }
}

// MARK: - View Extensions

extension View {
    /// Applies a rounded, blurred background to the view.
    /// - Parameters:
    ///   - style: The style of the blur effect.
    ///   - padding: The padding around the content. Defaults to 10.
    ///   - opacity: The opacity of the blur effect. Defaults to 1.0.
    ///   - radius: The corner radius of the rounded rectangle. Defaults to 16.
    /// - Returns: A view with a rounded, blurred background.
    func roundedBlurBackground(
        style: UIBlurEffect.Style,
        padding: CGFloat = 10,
        opacity: CGFloat = 1.0,
        radius: CGFloat = 16
    ) -> some View {
        modifier(RoundedBlurBackground(style: style, padding: padding, opacity: opacity, radius: radius))
    }
}
