//
//  ExploreBar.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/16/24.
//

import SwiftUI
import UIKit

struct ToolBarView: View {
    @Environment(AppState.self) private var appState: AppState
    @Binding var isCollapsed: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            MediaModeSwitchView()
            SearchTriggerView(isCollapsed: $isCollapsed)
        }
        .animation(.smooth(duration: 0.15), value: isCollapsed)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var searchBarViewModel: SearchBarViewModel = SearchBarViewModel()
        
        var body: some View {
            VStack {
                ToolBarView(isCollapsed: .constant(false))
                    .environment(AppState())
                Spacer()
            }
            .padding()
            .hueBackground(hueColor: .pink)
        }
    }
    return PreviewWrapper()
}
