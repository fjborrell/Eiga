//
//  SearchView.swift
//  Eiga
//
//  Created by Fernando Borrell on 8/4/24.
//

import SwiftUI
import OSLog

/// A view wiew that allows the user to search for media, and browse results.
@MainActor
struct SearchView: View {
    // MARK: - Environment
    @Environment(AppState.self) private var appState: AppState
    
    // MARK: - State
    @State private var viewModel = ExploreViewModel()
    @State private var resultFilter: ExploreFilter? = .latest
    
    // MARK: - Computed Properties
    var foregroundColor: Color {
        get {
            appState.selectedMediaMode.color
        }
    }
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { geo in
                Rectangle()
                    .fill(LinearGradient(colors: [appState.selectedMediaMode.color.opacity(0.4), .black], startPoint: .top, endPoint: .bottom))
                    .frame(width: geo.size.width, height: geo.safeAreaInsets.top + 70)
                    .ignoresSafeArea()
            }
            
            ToolBarView(isCollapsed: .constant(false))
                .padding()
            
            
            ScrollView {
                DynamicBlock(title: "Results", selectedFilter: $resultFilter) { filter in
                    
                }
            }
            .padding(.top, 70)
            .padding()
        }
        .background(LinearGradient(colors: [.black, .onyx], startPoint: .top, endPoint: .bottom))
    }
}

// MARK: - SearchViewModel

/// ViewModel for the SearchView, managing data fetching and UI state.
@Observable
@MainActor
class SearchViewModel {
    // MARK: - Dependencies
    private let tmbdService: TMBDService = TMBDService()
    
    // MARK: - State
    var searchBarViewModel: SearchBarViewModel = SearchBarViewModel()
    var isLoading = false
    var errorMessage: String?
    
    var resultFilter: ExploreFilter? = .popular
    var results: [any Media] = []
    
    var scrollPosition: ScrollPosition = ScrollPosition(idType: String.self)
    var isShowingScrollToTop: Bool = false
    
    // MARK: - Public Methods
    
    /// Fetches initial data for the explore view, including movies and featured content.
    func fetchInitialData() async {
        await fetchMovies()
    }
    
    // MARK: - Private Methods
    
    /// Fetches movies for the explore section.
    private func fetchMovies() async {
        isLoading = true
        errorMessage = nil
        do {
            results = try await tmbdService.fetchNowPlayingMovies()
        } catch {
            errorMessage = "Failed to fetch movies: \(error)"
        }
        isLoading = false
    }
}

// MARK: - Preview

#Preview {
    SearchView()
        .environment(AppState())
}
