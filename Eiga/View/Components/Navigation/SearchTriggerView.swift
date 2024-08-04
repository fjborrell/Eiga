//
//  SearchTriggerView.swift
//  Eiga
//
//  Created by Fernando Borrell on 8/1/24.
//

import SwiftUI

/// A view that displays a search trigger button with collapsible and expandable states.
struct SearchTriggerView: View {
    // MARK: - Environment
    @Environment(AppState.self) var appState: AppState
    
    // MARK: - State
    
    /// Determines whether the view is in a collapsed state.
    @Binding var isCollapsed: Bool
    
    // MARK: - Constants
    
    private let backgroundColor: Color = .black.opacity(0.8)
    private let overlayColor: Color = .white.opacity(0.8)
    
    // MARK: - Properties
    
    /// A closure to be executed when the button is tapped.
    var tapHandler: () -> Void = {}
    
    // MARK: - Body
    
    var body: some View {
        Button(action: tapHandler, label: {
            Group {
                if isCollapsed {
                    collapsedView
                } else {
                    expandedView
                }
            }
            .transition(.blurReplace().animation(.easeInOut(duration: 0.15)))
        })
        .buttonStyle(.plain)
    }
    
    // MARK: - Private Views
    
    /// The expanded view of the search trigger.
    private var expandedView: some View {
        HStack {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(backgroundColor)
                    .frame(height: 36)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(overlayColor)
                    
                    Text("Search")
                        .foregroundColor(overlayColor.opacity(0.7))
                        .font(.manrope(15))
                }
                .padding(.leading, 10)
            }
        }
    }
    
    /// The collapsed view of the search trigger.
    private var collapsedView: some View {
        Image(systemName: "magnifyingglass.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .symbolRenderingMode(.palette)
            .foregroundStyle(.white, appState.selectedMediaMode.color) // Multi-color symbol rendering
            .frame(width: 36, height: 36)
    }
}

/// A preview provider for the SearchTriggerView.
struct SearchTriggerPreview: View {
    // MARK: - State
    
    @State private var isCollapsed = false
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            SearchTriggerView(isCollapsed: $isCollapsed) {
                print("Action")
            }
            .padding()
            
            Toggle("Expanded", isOn: $isCollapsed)
                .padding()
        }
        .background(Color.gray)
    }
}

// MARK: - Preview

#Preview {
    SearchTriggerPreview()
        .environment(AppState())
}
