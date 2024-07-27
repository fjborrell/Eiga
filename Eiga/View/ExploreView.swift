//
//  ExploreView.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/20/24.
//

import SwiftUI

struct ExploreView: View {
    private let tmbdService: TMBDService = TMBDService()
    @Environment(AppState.self) var appState: AppState
    @State var exploreFilter: ExploreFilter? = .popular
    @State var searchBarViewModel: SearchBarViewModel = SearchBarViewModel()
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State var media: [any Media] = []
    private let mediaRepository = TMBDService()
    
    var body: some View {
        VStack {
            LogoView()
            BrosweBarView(searchBarViewModel: $searchBarViewModel)
                .padding(.vertical, 10)
            
            DynamicBlock(title: "Explore Block", selectedFilter: $exploreFilter) { filter in
                if isLoading {
                    ProgressView()
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    PosterGridView(media: media)
                }
            }
        }
        .task {
            await fetchMovies()
        }
    }
    
    private func fetchMovies() async {
        isLoading = true
        errorMessage = nil
        do {
            self.media = try await tmbdService.fetchNowPlayingMovies()
        } catch {
            errorMessage = "Failed to fetch movies: \(error)"
        }
        isLoading = false
    }
}

#Preview {
    ExploreView()
        .environment(AppState())
        .hueBackground(hueColor: .pink)
}
