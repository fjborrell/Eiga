//
//  SearchBarView.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/15/24.
//

import Foundation
import SwiftUI
import SwiftUI

struct SearchBarView: View {
    @FocusState private var isFocused: Bool
    @Binding var query: String
    @Binding var state: SearchState
    
    var body: some View {
        HStack(spacing: 10) {
            ZStack(alignment: .trailing) {
                TextField("", text: $query, prompt: searchPrompt)
                    .frame(height: 36)
                    .padding(.horizontal, 36)
                    .background(Color.gray.opacity(0.24))
                    .cornerRadius(10)
                    .focused($isFocused)
                    .foregroundStyle(.white)
                    .font(.manrope(15))
                    .onChange(of: isFocused) { _, newState in
                        if newState {
                            state = .active
                        }
                    }
                    .onChange(of: query) { _, _ in
                        state = query.isEmpty && !isFocused ? .inactive : .active
                    }
                
                searchOverlay
            }
            
            if isActive() {
                Button("Cancel") {
                    switchSearchState(.inactive)
                }
                .font(.manrope(15))
                .foregroundColor(.white)
                .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity.animation(.easeInOut(duration: 1))), removal: .move(edge: .trailing).combined(with: .opacity.animation(.easeInOut(duration: 0.1)))))
            }
        }
        .animation(.default, value: state)
    }
    
    private func clearQuery() {
        self.query = ""
    }
    
    private func switchSearchState(_ state: SearchState) {
        self.state = state
        isFocused = isActive()
        if state == .inactive {
            clearQuery()
        }
    }
    
    private func isActive() -> Bool {
        return self.state == .active
    }
    
    private var searchPrompt: Text {
        Text("Search")
            .font(.manrope(15))
            .foregroundStyle(.gray)
    }
    
    private var searchOverlay: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.gray)
                .padding(.leading, 10)
            
            Spacer()
            
            if isActive() {
                Button(action: clearQuery) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.gray)
                }
                .padding(.trailing, 10)
                .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity.animation(.easeInOut(duration: 1))), removal: .move(edge: .trailing).combined(with: .opacity.animation(.easeInOut(duration: 0.1)))))
            }
        }
    }
}

public enum SearchState {
    case inactive
    case active
}

struct TestView: View {
    @State private var query = ""
    @State private var state: SearchState = .inactive
    
    var body: some View {
        VStack {
            SearchBarView(query: $query, state: $state)
                .padding()
            Spacer()
        }
        .background(Color.black)
    }
}

#Preview {
    TestView()
}
