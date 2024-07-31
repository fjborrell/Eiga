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
    
    @State var scrollPosition: ScrollPosition = ScrollPosition(idType: String.self)
    @State var isShowingScrollToTop: Bool = false
    @State var scrollOffset: CGFloat = 0.0
    @State var logoOpacity: CGFloat = 1.0
    @State var searchIsCollapsed: Bool = false
    
    let stickyThreshold: CGFloat = 40
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 10) {
                // Tool Bar
                LogoView()
                    .opacity(logoOpacity)
                    .padding(.top, 10)
                
                BrosweBarView(searchBarViewModel: $searchBarViewModel, isCollapsed: $searchIsCollapsed)
                    .offset(y: calculateBarOffset())
                    .zIndex(1)
                
                //Featured
                StaticBlock(title: "Featured") {
                    GeometryReader { geometry in
                        MultiBlobView(
                            activeIndex: $activeBlobIndex,
                            items: self.$featuredMedia,
                            containerWidth: geometry.size.width,
                            containerHeight: 190,
                            activeBlobRatio: 0.8
                        )
                    }
                    .frame(height: 225)
                }
                
                // Explore
                DynamicBlock(title: "Explore", selectedFilter: $exploreFilter) { filter in
                    PosterGridView(media: self.$exploreMedia)
                        .padding(.bottom, 120)
                }
            }
        }
        .task {
            await fetchMovies()
            await fetchFeatured()
        }
        .scrollIndicators(.never)
        .scrollPosition($scrollPosition)
        .onScrollGeometryChange(for: CGFloat.self) { geometry in
            geometry.contentOffset.y
        } action: { oldValue, newValue in
            scrollOffset = newValue + 60
            
            let clampedValue = max(0, min(44, scrollOffset))
            let normalizedOpacity = clampedValue.normalize(min: 0, max: 44)
            self.logoOpacity = 1 - normalizedOpacity
            
            withAnimation(.smooth) {
                isShowingScrollToTop = scrollOffset > 300
                searchIsCollapsed = scrollOffset > stickyThreshold * 2.0
            }
        }
        .overlay(alignment: .bottomTrailing) {
            if isShowingScrollToTop {
                makeScrollToTopButton()
                    .padding(.bottom, 120)
                    .transition(
                        .move(edge: .bottom)
                        .combined(with: .blurReplace)
                    )
            }
        }
        
        
    }
    
    private func calculateBarOffset() -> CGFloat {
        if scrollOffset < stickyThreshold {
            return 0 // Bar scrolls normally
        } else {
            return scrollOffset - stickyThreshold // Bar sticks at threshold
        }
    }
    
    @ViewBuilder
    private func makeScrollToTopButton() -> some View {
        Button(action: {
            withAnimation(.smooth) {
                self.scrollPosition.scrollTo(edge: .top)
            }
        }, label: {
            Image(systemName: "arrow.uturn.up.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .pink)
                .frame(width: 40, height: 40)
                .opacity(0.9)
        })
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
