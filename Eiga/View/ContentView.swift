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
    
    var body: some View {
        ZStack {
            selectedContent
                .padding(.horizontal, 15)
                
            VStack {
                Spacer()
                TabBarView(selectedTab: $selectedTab)
            }
            .ignoresSafeArea()
        }
        .hueBackground(hueColor: .pink)
    }
    
    
}

#Preview {
    ContentView()
}
