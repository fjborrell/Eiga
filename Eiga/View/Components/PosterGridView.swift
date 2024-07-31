//
//  PosterGridView.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/25/24.
//

import Foundation
import SwiftUI

struct PosterGridView: View {
    @Binding var media: [any Media]
    @State private var currentScale: CGFloat = 1.0
    let scaleSteps: (CGFloat, CGFloat) = (1.0, 1.4)
    
    let baseColumnWidth: CGFloat = 100
    let widthSpacing: CGFloat = 5
    let verticalSpacing: CGFloat = 20
    
    var body: some View {
        let columns = [
            GridItem(.adaptive(minimum: baseColumnWidth * currentScale, maximum: baseColumnWidth * currentScale * 1.5), spacing: widthSpacing)
        ]
        
        LazyVGrid(columns: columns, spacing: verticalSpacing) {
            ForEach(Array(media.enumerated()), id: \.element.id) { _, item in
                PosterView(viewModel: PosterViewModel(media: item))
                    .id(item.id)
                    .scrollTransition(.animated.threshold(.visible(0.3))) { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1 : 0.4)
                            .scaleEffect(phase.isIdentity ? 1 : 0.85)
                            .blur(radius: phase.isIdentity ? 0 : 8)
                    }
            }
        }
        
        .gesture(
            MagnifyGesture()
                .onEnded { value in
                    withAnimation(.smooth) {
                        currentScale = value.magnification > 1 ? scaleSteps.1 : scaleSteps.0
                    }
                }
        )
    }
}

