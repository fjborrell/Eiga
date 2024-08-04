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
    // MARK: - Environment
    @Environment(AppState.self) private var appState: AppState
    
    // MARK: - State
    @State private var viewModel = ExploreViewModel()
    
    // MARK: - Computed Properties
    var foregroundColor: Color {
        get {
            appState.selectedMediaMode.color
        }
    }
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .top) {
            scrollContent
                .overlay(alignment: .bottomTrailing) {
                    if viewModel.isShowingScrollToTop {
                        scrollToTopButton
                            .padding(.bottom, 120)
                            .transition(.move(edge: .bottom))
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
                        .frame(height: geo.safeAreaInsets.top * 2.85)
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
                if viewModel.isToolbarCollapsed {
                    Spacer()
                }
                ToolBarView(isCollapsed: $viewModel.isToolbarCollapsed)
                .roundedBlurBackground(
                    style: .systemUltraThinMaterialDark
                )
            }
            Spacer()
        }
        .offset(y: viewModel.calculateBarOffset())
    }
    
    /// Creates a button that scrolls the view to the top when tapped.
    @ViewBuilder
    private var scrollToTopButton: some View {
        Button(action: {
            withAnimation(.smooth) {
                viewModel.scrollPosition.scrollTo(edge: .top)
            }
        }, label: {
            Image(systemName: "arrow.uturn.up.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, self.foregroundColor)
                .frame(width: 36, height: 36)
        })
    }
}

// MARK: - ExploreViewModel

/// ViewModel for the ExploreView, managing data fetching and UI state.
@Observable
@MainActor
class ExploreViewModel {
    // MARK: - Dependencies
    private let tmbdService: TMBDService = TMBDService()
    private let mediaRepository = TMBDService()
    
    // MARK: - State
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
    var searchBarBlurOpacity: CGFloat = 1.0
    var isToolbarCollapsed: Bool = false
    
    // MARK: - Constants
    private let stickyThreshold: CGFloat = 40
    
    // MARK: - Public Methods
    
    /// Fetches initial data for the explore view, including movies and featured content.
    func fetchInitialData() async {
        await fetchMovies()
        await fetchFeatured()
    }
    
    /// Updates the scroll state and adjusts UI elements based on the current scroll position.
    /// - Parameter newValue: The new scroll offset value.
    func updateScrollState(_ newValue: CGFloat) {
        scrollOffset = newValue
        
        // Calculate toolbar opacities based on scroll position
        logoOpacity = 1 - scrollOffset.normalize(min: 0, max: 30)
        searchBarBlurOpacity = scrollOffset.normalize(min: 0, max: 70)
        
        withAnimation(.smooth(duration: 0.1)) {
            isShowingScrollToTop = scrollOffset > 300
            isToolbarCollapsed = scrollOffset > stickyThreshold * 2.5
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
    
    // MARK: - Private Methods
    
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
            featuredMedia = movies.prefix(upTo: 3).map { BlobMedia(media: $0) } // Convert first 3 movies to BlobMedia
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
