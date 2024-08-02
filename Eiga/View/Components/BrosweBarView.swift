//
//  ExploreBar.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/16/24.
//

import SwiftUI
import UIKit

struct BrosweBarView: View {
    @Environment(AppState.self) private var appState: AppState
    @Binding var searchBarViewModel: SearchBarViewModel
    @Binding var isCollapsed: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            MediaModeSwitchView()
            SearchBarView(viewModel: searchBarViewModel)
        }
        .animation(.bouncy(extraBounce: -0.2), value: isCollapsed)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var searchBarViewModel: SearchBarViewModel = SearchBarViewModel()
        
        var body: some View {
            VStack {
                BrosweBarView(searchBarViewModel: $searchBarViewModel, isCollapsed: .constant(true))
                    .environment(AppState())
                Spacer()
            }
            .padding()
            .hueBackground(hueColor: .pink)
        }
    }
    return PreviewWrapper()
}
