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
    @Binding var isCollapsed: Bool
    
    private var makeBackground: some View {
        CustomBlurView(style: .systemUltraThinMaterialDark)
            .opacity(isCollapsed ? 1.0 : 0.5)
    }
    
    var body: some View {
        HStack {
            if isCollapsed {
                Spacer()
            }
            HStack(spacing: 10) {
                MediaModeSwitchView()
                    .padding([.vertical, .leading], 10)
                SearchBarView(viewModel: searchBarViewModel, isCollapsed: $isCollapsed)
                    .padding([.vertical, .trailing], 10)
            }
            .animation(.bouncy(extraBounce: -0.2), value: isCollapsed)
            .background(makeBackground)
            .cornerRadius(16)
        }
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
