//
//  ExploreView.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/20/24.
//

import SwiftUI
import OSLog

// MARK: - ExploreView

/// A dynamic view that enables exploration of varied media types.
@MainActor
struct ExploreView: View {
    @Environment(AppState.self) private var appState: AppState
    @State private var viewModel = ExploreViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            scrollContent
                .overlay(alignment: .bottomTrailing) {
                    if viewModel.isShowingScrollToTop {
                        makeScrollToTopButton()
                    }
                }
            
            toolbarView
        }
        .task {
            await viewModel.fetchInitialData()
        }
    }
    
    // MARK: - Subviews
    
    /// The main scrollable content of the view, including the featured and explore sections.
    @ViewBuilder
    private var scrollContent: some View {
        GeometryReader { geo in
            ScrollView(.vertical) {
                VStack {
                    // Spacer to push content below the safe area
                    Color.clear
                        .frame(height: geo.safeAreaInsets.top * 3)
                }
                .ignoresSafeArea()
                
                LazyVStack(spacing: 10) {
                    featuredSection
                    exploreSection
                }
            }
            .scrollIndicators(.never)
            .scrollPosition($viewModel.scrollPosition)
            .onScrollGeometryChange(for: CGFloat.self) { geometry in
                geometry.contentOffset.y
            } action: { oldValue, newValue in
                viewModel.updateScrollState(newValue)
            }
            .ignoresSafeArea()
        }
    }
    
    /// Displays featured media content in a carousel.
    @ViewBuilder
    private var featuredSection: some View {
        StaticBlock(title: "Featured") {
            GeometryReader { geometry in
                MultiBlobView(
                    activeIndex: $viewModel.activeBlobIndex,
                    items: $viewModel.featuredMedia,
                    containerWidth: geometry.size.width,
                    containerHeight: 190,
                    activeBlobRatio: 0.8
                )
            }
            .frame(height: 225)
        }
    }
    
    /// Displays a grid of media posters that can be filtered.
    @ViewBuilder
    private var exploreSection: some View {
        DynamicBlock(
            title: "Explore",
            selectedFilter: $viewModel.exploreFilter
        ) { filter in
            PosterGridView(media: $viewModel.exploreMedia)
                .padding(.bottom, 120)
        }
    }
    
    /// The toolbar view containing the logo, search bar, and media mode.
    @ViewBuilder
    private var toolbarView: some View {
        VStack {
            LogoView()
                .opacity(viewModel.logoOpacity)
            HStack {
                if viewModel.searchIsCollapsed {
                    Spacer()
                }
                BrosweBarView(
                    searchBarViewModel: $viewModel.searchBarViewModel,
                    isCollapsed: $viewModel.searchIsCollapsed
                )
                .roundedBlurBackground(
                    style: .systemUltraThinMaterialDark,
                    opacity: viewModel.searchIsCollapsed ? 1.0 : 0.5
                )
            }
            Spacer()
        }
        .offset(y: viewModel.calculateBarOffset())
    }
    
    // MARK: - Helper Methods
    
    /// Creates a button that scrolls the view to the top when tapped.
    @ViewBuilder
    private func makeScrollToTopButton() -> some View {
        Button(action: {
            withAnimation(.smooth) {
                viewModel.scrollPosition.scrollTo(edge: .top)
            }
        }, label: {
            Image(systemName: "arrow.uturn.up.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .pink)
                .frame(width: 40, height: 40)
                .opacity(0.9)
        })
        .roundedBlurBackground(
            style: .systemUltraThinMaterialDark,
            padding: 7,
            radius: 25
        )
        .padding(.bottom, 120)
        .transition(
            .move(edge: .bottom)
            .combined(with: .blurReplace)
        )
    }
}

// MARK: - ExploreViewModel

/// ViewModel for the ExploreView, managing data fetching and UI state.
@Observable
@MainActor
class ExploreViewModel {
    private let tmbdService: TMBDService = TMBDService()
    private let mediaRepository = TMBDService()
    
    var searchBarViewModel: SearchBarViewModel = SearchBarViewModel()
    var isLoading = false
    var errorMessage: String?
    
    var featuredMedia: [BlobMedia] = []
    var activeBlobIndex: Int = 0
    
    var exploreFilter: ExploreFilter? = .popular
    var exploreMedia: [any Media] = []
    
    var scrollPosition: ScrollPosition = ScrollPosition(idType: String.self)
    var isShowingScrollToTop: Bool = false
    var scrollOffset: CGFloat = 0.0
    var logoOpacity: CGFloat = 1.0
    var searchIsCollapsed: Bool = false
    
    private let stickyThreshold: CGFloat = 40
    
    /// Fetches initial data for the explore view, including movies and featured content.
    func fetchInitialData() async {
        await fetchMovies()
        await fetchFeatured()
    }
    
    /// Updates the scroll state and adjusts UI elements based on the current scroll position.
    /// - Parameter newValue: The new scroll offset value.
    func updateScrollState(_ newValue: CGFloat) {
        scrollOffset = newValue
        
        // Calculate logo opacity based on scroll position
        let clampedValue = max(0, scrollOffset)
        let normalizedOpacity = clampedValue.normalize(min: 0, max: 30)
        logoOpacity = 1 - normalizedOpacity
        
        withAnimation(.smooth) {
            isShowingScrollToTop = scrollOffset > 300
            searchIsCollapsed = scrollOffset > stickyThreshold * 2.0
        }
    }
    
    /// Calculates the vertical offset for the toolbar based on the current scroll position.
    /// - Returns: The calculated offset value.
    func calculateBarOffset() -> CGFloat {
        if scrollOffset <= stickyThreshold {
            return -scrollOffset // Bar stays at top until threshold
        } else {
            return -stickyThreshold // Bar sticks at threshold
        }
    }
    
    /// Fetches movies for the explore section.
    private func fetchMovies() async {
        isLoading = true
        errorMessage = nil
        do {
            exploreMedia = try await tmbdService.fetchNowPlayingMovies()
        } catch {
            errorMessage = "Failed to fetch movies: \(error)"
        }
        isLoading = false
    }
    
    /// Fetches featured media content.
    private func fetchFeatured() async {
        do {
            let movies = try await tmbdService.fetchPopularMovies()
            featuredMedia = movies.prefix(upTo: 3).map { BlobMedia(media: $0) }
        } catch {
            errorMessage = "Failed to fetch movies: \(error)"
        }
    }
}

// MARK: - Preview

#Preview {
    ExploreView()
        .environment(AppState())
        .hueBackground(hueColor: .pink)
}
