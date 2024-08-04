//
//  HueBackground.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/16/24.
//

import Foundation
import SwiftUI

/// A view modifier that creates a stylized background with a hue color effect.
///
/// This modifier applies a complex background consisting of a black base,
/// a colored hue gradient, and a blurred top safe-area.
struct HueBackground: ViewModifier {
    // MARK: - Properties
    
    /// The color used for the hue effect in the background.
    var hueColor: Color
    
    // MARK: - View Modifier
    
    /// Applies the hue background effect to the given content.
    /// - Parameter content: The content to which the background will be applied.
    /// - Returns: A view with the hue background effect applied.
    func body(content: Content) -> some View {
        ZStack {
            backgroundLayers
            content
            blurredTopArea
        }
        .animation(.smooth, value: hueColor)
    }
    
    // MARK: - Private Views
    
    /// The main background layers including the black base and colored hue.
    private var backgroundLayers: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(.black)
                
                coloredHueLayer(in: geometry)
            }
            .ignoresSafeArea()
        }
    }
    
    /// Creates the colored hue layer with a gradient effect.
    /// - Parameter geometry: The geometry proxy of the parent view.
    /// - Returns: A view representing the colored hue layer.
    private func coloredHueLayer(in geometry: GeometryProxy) -> some View {
        Ellipse()
            .fill(
                LinearGradient(
                    colors: [
                        hueColor.opacity(0.85),
                        .clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .position(x: geometry.size.width / 2, y: 0) // Center the hue horizontally
            .offset(y: -geometry.size.height * 0.25) // Raise to top quarter of screen
            .frame(
                width: geometry.size.width * 1.5, // Widen by 50%
                height: geometry.size.height * 0.4 // 40% of screen height
            )
            .blur(radius: 40)
    }
    
    /// A blurred area at the top of the screen for blending with the status bar.
    private var blurredTopArea: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    CustomBlurView(style: .systemUltraThinMaterialDark)
                    Rectangle()
                        .fill(hueColor)
                        .opacity(0.6)
                    Rectangle()
                        .fill(Color.black)
                        .opacity(0.37)  // Adjusts the darkness of the blur
                }
                .frame(height: geometry.safeAreaInsets.top)
                
                Spacer()
            }
            .ignoresSafeArea()
        }
    }
}

// MARK: - View Extension

extension View {
    /// Applies the hue background effect to a view.
    /// - Parameter hueColor: The color to be used for the hue effect.
    /// - Returns: A view with the hue background effect applied.
    func hueBackground(hueColor: Color) -> some View {
        modifier(HueBackground(hueColor: hueColor))
    }
}

// MARK: - Preview

#Preview {
    ZStack() {
        
    }
    .hueBackground(hueColor: .pink)
}
