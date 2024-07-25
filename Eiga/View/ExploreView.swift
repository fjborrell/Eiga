//
//  ExploreView.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/20/24.
//

import SwiftUI

// Update ExploreView
struct ExploreView: View {
    private let tmbdService: TMBDService = TMBDService()
    @State var exploreFilter: ExploreFilter? = .popular
    @State var searchBarViewModel: SearchBarViewModel = SearchBarViewModel()
    @State var displayedMedia: [Movie] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    private let mediaRepository = TMBDService()
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundStyle(.white)
            
            BrosweBarView(searchBarViewModel: $searchBarViewModel)
                .padding(.vertical, 10)
            
            DynamicBlock(title: "Explore Block", selectedFilter: $exploreFilter) { filter in
                if isLoading {
                    ProgressView()
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    ScrollView(showsIndicators: false) {
                        ForEach(displayedMedia, id: \.id) { media in
                            Text(media.title)
                        }
                    }
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
            displayedMedia = try await tmbdService.fetchNowPlayingMovies().results 
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
