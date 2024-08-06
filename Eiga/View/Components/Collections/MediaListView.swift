//
//  MediaListView.swift
//  Eiga
//
//  Created by Fernando Borrell on 8/5/24.
//

import SwiftUI

struct MediaListView: View {
    @State var rows: [MediaRowViewModel] = []
    var body: some View {
        List() {
            ForEach(Array(rows.enumerated()), id: \.element.media.id) { _, item in
                MediaRowView(viewModel: item)
                    .listRowBackground(Color.onyx)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.black)
    }
}

// MARK: - Preview

private struct PreviewWrapper: View {
    let tmbd = TMBDService()
    @State var movie: (any Media)?
    @State var movies: [MediaRowViewModel] = []
    
    var body: some View {
        Group {
            if let movie = movie {
                let m = MediaRowViewModel(media: movie)
                MediaListView(rows: Array(repeating: m, count: 10))
            } else {
                ProgressView()
            }
        }
        .task {
            do {
                self.movie = try await tmbd.fetchMovie(id: 810693)
            } catch {
                print("Error fetching movie: \(error)")
            }
        }
    }
}

#Preview {
    PreviewWrapper()
}
