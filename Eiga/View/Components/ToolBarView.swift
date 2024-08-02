//
//  ExploreBar.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/16/24.
//

import SwiftUI
import UIKit

// MARK: - ToolBarView

/// A view that represents the toolbar containing media mode switch and search trigger.
struct ToolBarView: View {
    // MARK: Environment
    
    @Environment(AppState.self) private var appState: AppState
    
    // MARK: Bindings
    
    /// Binding to control the collapsed state of the toolbar.
    @Binding var isCollapsed: Bool
    
    // MARK: Body
    
    var body: some View {
        HStack(spacing: 10) {
            MediaModeSwitchView()
            SearchTriggerView(isCollapsed: $isCollapsed)
        }
        .animation(.smooth(duration: 0.15), value: isCollapsed)
        // Animate the HStack when isCollapsed changes
    }
}

// MARK: - Preview

#Preview {
    /// A wrapper view for previewing ToolBarView
    struct PreviewWrapper: View {
        // MARK: State
        
        @State var searchBarViewModel: SearchBarViewModel = SearchBarViewModel()
        
        // MARK: Body
        
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
