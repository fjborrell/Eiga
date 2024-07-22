//
//  ExploreView.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/20/24.
//

import SwiftUI

struct ExploreView: View {
    @State var exploreFilter: ExploreFilter? = .popular
    @State var searchQuery: String = ""
    @State var searchState: SearchState = .inactive
    
    var jjk: some View {
        Image("jjk")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 370, height: 170)
    }
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundStyle(.white)
            
            ExploreBarView(query: $searchQuery, state: $searchState)
                .padding(.vertical, 10)
            
            DynamicBlock(title: "Explore Block", selectedFilter: $exploreFilter) { block in
                ScrollView {
                    ForEach(0..<6) { _ in
                        exploreFilter == .popular ? jjk : jjk
                    }
                }
            }
        }
    }
}

#Preview {
    ExploreView()
        .environment(AppState())
        .hueBackground(hueColor: .pink)
}
