//
//  Tab.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/18/24.
//

import Foundation
import SwiftUI

/// A custom tab bar view for the main navigation of the app.
struct TabBarView: View {
    // MARK: - State
    @Binding var selectedTab: Tab
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            tabBarBackground
            tabBarContent
        }
        .frame(width: .infinity, height: 105)
    }
    
    // MARK: - Subviews
    
    /// The background of the tab bar.
    private var tabBarBackground: some View {
        Rectangle()
            .fill(LinearGradient.tabBar)
    }
    
    /// The content of the tab bar, including tab items and the add button.
    private var tabBarContent: some View {
        HStack {
            ForEach(Tab.allCases.prefix(2), id: \.self) { tab in
                TabView(selectedTab: $selectedTab, tab: tab)
            }
            
            AddButton()
            
            ForEach(Tab.allCases.suffix(2), id: \.self) { tab in
                TabView(selectedTab: $selectedTab, tab: tab)
            }
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 20)
    }
    
    // MARK: - Nested Views
    
    /// A button for adding new content.
    struct AddButton: View {
        @State private var animationTrigger: Bool = false
        
        var body: some View {
            Button(action: {
                animationTrigger.toggle()
                // TODO: Implement add sheet functionality
            }, label: {
                VStack {
                    Image(systemName: "plus.app")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28)
                        .symbolRenderingMode(.hierarchical)
                        .symbolEffect(.bounce, value: animationTrigger)
                        .foregroundStyle(.green)
                    Text("Add")
                        .font(.manrope(12))
                        .foregroundStyle(.white)
                }
            })
            .frame(maxWidth: .infinity)
            .buttonStyle(.plain)
        }
    }
        
    /// A view representing a single tab item.
    struct TabView: View {
        // MARK: - Environment
        @Environment(AppState.self) var appState: AppState
        
        // MARK: - State
        @State private var animationTrigger: Bool = false
        @Binding var selectedTab: Tab
        
        // MARK: - Constants
        let tab: Tab
        
        // MARK: - Computed Properties
        var tabColor: Color {
            get {
                appState.selectedMediaMode.color
            }
        }
        
        // MARK: - Body
        var body: some View {
            Button(action: {
                selectedTab = tab
                animationTrigger.toggle()
            }, label: {
                VStack {
                    Image(systemName: tab.iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28)
                        .symbolEffect(.bounce, value: animationTrigger)
                        .foregroundStyle(isSelected() ? self.tabColor : .white)
                    Text(tab.title)
                        .font(.manrope(12))
                        .foregroundStyle(isSelected() ? self.tabColor : .white)
                }
            })
            .frame(maxWidth: .infinity)
            .buttonStyle(.plain)
        }
                
        /// Checks if the current tab is selected.
        private func isSelected() -> Bool {
            return selectedTab == tab
        }
    }
}

// MARK: - Preview

#Preview {
    VStack {
        Spacer()
        TabBarView(selectedTab: .constant(.explore))
    }
    .ignoresSafeArea()
    .hueBackground(hueColor: .pink)
    .environment(AppState())
}
