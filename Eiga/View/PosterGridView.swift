//
//  PosterGridView.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/25/24.
//

import Foundation
import SwiftUI

struct PosterGridView: View {
    @State private var viewModels: [PosterViewModel<Movie>]
    @State private var currentScale: CGFloat = 1.0
    let scaleSteps: (CGFloat, CGFloat) = (1.0, 1.4)
    
    let baseColumnWidth: CGFloat = 100
    
    init(movies: [Movie]) {
        _viewModels = State(initialValue: movies.map { PosterViewModel(media: $0) })
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                let columns = calculateColumns(for: geometry.size.width)
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModels.indices, id: \.self) { index in
                        PosterView(viewModel: viewModels[index])
                    }
                }
            }
        }
        .gesture(
            MagnifyGesture()
                .onEnded { value in
                    let newScale = value.magnification > 1 ? scaleSteps.1 : scaleSteps.0
                    updateAllScales(newScale)
                    currentScale = newScale
                }
        )
    }
    
    private func calculateColumns(for width: CGFloat) -> [GridItem] {
        let scaledColumnWidth = baseColumnWidth * currentScale
        let columnCount = max(1, Int(width / scaledColumnWidth))
        return Array(repeating: GridItem(.flexible()), count: columnCount)
    }
    
    private func updateAllScales(_ newScale: CGFloat) {
        for index in viewModels.indices {
            viewModels[index].updateScale(newScale)
        }
    }
}
