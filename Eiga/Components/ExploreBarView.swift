//
//  ExploreBar.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/16/24.
//

import SwiftUI

struct ExploreBarView: View {
    @Environment(AppState.self) private var appState: AppState
    @Binding var query: String
    @Binding var state: SearchState
    
    var body: some View {
        HStack(spacing: 10) {
            MediaModeSwitchView()
            SearchBarView(query: $query, state: $state)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var query: String = ""
        @State var state: SearchState = .inactive
        var body: some View {
            ExploreBarView(query: $query, state: $state)
                .environment(AppState())
        }
    }
    
    return PreviewWrapper()
}
