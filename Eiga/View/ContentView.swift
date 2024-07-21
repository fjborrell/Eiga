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
    @State var selectedTab: Tab = .explore
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Content layer
                VStack() {
                    selectedContent
                        .frame(width: geometry.size.width - 30)  // Apply padding here
                        .frame(maxWidth: .infinity)  // Expand to full width
                }
                
                // Tab Bar layer
                VStack {
                    Spacer()
                    TabBarView(selectedTab: $selectedTab)
                        .frame(width: geometry.size.width)  // Ensure full width
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .hueBackground(hueColor: .pink)
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
}
