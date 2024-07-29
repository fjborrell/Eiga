//
//  ContentView.swift
//  Eiga
//
//  Created by Fernando Borrell on 6/21/24.
//

import Foundation
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(AppState.self) private var appState
    @State var selectedTab: Tab = .explore
    let sidePadding: CGFloat = 18
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                // Content layer
                VStack() {
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

#Preview {
    ContentView()
        .environment(AppState())
}
