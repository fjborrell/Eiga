//
//  ExploreView.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/20/24.
//

import SwiftUI

struct ExploreView: View {
    @Environment(AppState.self) var appState: AppState
    private let tmbdService: TMBDService = TMBDService()
    private let mediaRepository = TMBDService()
    
    @State var searchBarViewModel: SearchBarViewModel = SearchBarViewModel()
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    @State var featuredMedia: [BlobMedia] = []
    @State var activeBlobIndex: Int = 0
    
    @State var exploreFilter: ExploreFilter? = .popular
    @State var exploreMedia: [any Media] = []
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 10) {
                // Tool Bar
                LogoView()
                BrosweBarView(searchBarViewModel: $searchBarViewModel)
                    .padding(.vertical, 10)
                
                //Featured
                StaticBlock(title: "Featured") {
                    MultiBlobView(
                        activeIndex: $activeBlobIndex,
                        items: self.featuredMedia,
                        containerWidth: geometry.size.width,
                        containerHeight: 190,
                        blobWidth: 280)
                }
                
                // Explore
                DynamicBlock(title: "Explore", selectedFilter: $exploreFilter) { filter in
                    if isLoading {
                        ProgressView()
                    } else if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    } else {
                        PosterGridView(media: self.exploreMedia)
                    }
                }
            }
        }
        .task {
            await fetchMovies()
            await fetchFeatured()
        }
    }
    
    private func fetchMovies() async {
        isLoading = true
        errorMessage = nil
        do {
            self.exploreMedia = try await tmbdService.fetchNowPlayingMovies()
        } catch {
            errorMessage = "Failed to fetch movies: \(error)"
        }
        isLoading = false
    }
    
    private func fetchFeatured() async {
        do {
            let movies = try await tmbdService.fetchPopularMovies()
            self.featuredMedia = movies.prefix(upTo: 3).map{ BlobMedia(media: $0) }
        } catch {
            errorMessage = "Failed to fetch movies: \(error)"
        }
    }
}

#Preview {
    ExploreView()
        .environment(AppState())
        .hueBackground(hueColor: .pink)
}
