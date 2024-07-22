//
//  ExploreBar.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/16/24.
//

import SwiftUI

struct BrosweBarView: View {
    @Environment(AppState.self) private var appState: AppState
    @Binding var searchBarViewModel: SearchBarViewModel
    
    var body: some View {
        HStack(spacing: 10) {
            MediaModeSwitchView()
            SearchBarView(viewModel: searchBarViewModel)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var searchBarViewModel: SearchBarViewModel = SearchBarViewModel()
        
        var body: some View {
            BrosweBarView(searchBarViewModel: $searchBarViewModel)
                .environment(AppState())
        }
    }
    return PreviewWrapper()
}
