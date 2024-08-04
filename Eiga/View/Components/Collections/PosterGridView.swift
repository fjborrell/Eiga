//
//  PosterGridView.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/25/24.
//

import Foundation
import SwiftUI

/// A view that displays a grid of media posters with zooming capability.
struct PosterGridView: View {
    // MARK: - State
    
    /// The collection of media items to display.
    @Binding var media: [any Media]
    
    /// The current scale factor for the grid items.
    @State private var currentScale: CGFloat = 1.0
    
    // MARK: - Constants
    
    /// The minimum and maximum scale factors for the grid.
    let scaleSteps: (CGFloat, CGFloat) = (1.0, 1.4)
    
    /// The base width for each column in the grid.
    let baseColumnWidth: CGFloat = 100
    
    /// The horizontal spacing between grid items.
    let widthSpacing: CGFloat = 5
    
    /// The vertical spacing between grid items.
    let verticalSpacing: CGFloat = 20
    
    // MARK: - Body
    
    var body: some View {
        // Define the grid layout
        let columns = [
            GridItem(.adaptive(minimum: baseColumnWidth * currentScale, maximum: baseColumnWidth * currentScale * 1.5), spacing: widthSpacing)
        ]
        
        LazyVGrid(columns: columns, spacing: verticalSpacing) {
            ForEach(Array(media.enumerated()), id: \.element.id) { _, item in
                PosterView(viewModel: PosterViewModel(media: item))
                    .id(item.id)
                    .scrollTransition(.animated.threshold(.visible(0.3))) { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1 : 0.5)
                            .scaleEffect(phase.isIdentity ? 1 : 0.85)
                    }
            }
        }
        .gesture(
            MagnifyGesture()
                .onEnded { value in
                    withAnimation(.smooth) {
                        // Adjust the scale based on the pinch gesture
                        currentScale = value.magnification > 1 ? scaleSteps.1 : scaleSteps.0
                    }
                }
        )
    }
}

