//
//  ContentView.swift
//  Eiga
//
//  Created by Fernando Borrell on 6/21/24.
//

import Foundation
import SwiftUI
import SwiftData

/// The main content view of the application, managing the tab-based navigation and overall layout.
struct ContentView: View {
    // MARK: - Environment
    
    @Environment(AppState.self) private var appState
    
    // MARK: - State
    
    @State private var selectedTab: Tab = .explore
    @State private var showTopBlur: Bool = false
    
    // MARK: - Constants
    
    let sidePadding: CGFloat = 18
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                // Content layer
                VStack {
                    selectedContent
                        .padding(.horizontal, sidePadding)
                }
                .frame(width: geometry.size.width)
                
                // Tab Bar layer
                VStack {
                    Spacer()
                    TabBarView(selectedTab: $selectedTab)
                }
                .frame(width: geometry.size.width)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .hueBackground(hueColor: appState.selectedMediaMode.color)
    }
    
    // MARK: - View Builders
    
    /// Provides the appropriate view based on the selected tab.
    @ViewBuilder
    var selectedContent: some View {
        switch selectedTab {
        case .explore:
            ExploreView()
        case .library:
            LibraryView()
        case .crews:
            CrewsView()
        case .profile:
            ProfileView()
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
        .environment(AppState())
}
