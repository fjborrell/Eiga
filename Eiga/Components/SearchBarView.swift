//
//  SearchBarView.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/15/24.
//

import Foundation
import SwiftUI

// MARK: - Model

public enum SearchState {
    case inactive
    case active
}

// MARK: - View
// TODO: - onChange query and onChange focus is too volatile. Too many view updates. cancel is buggy because of this.

struct SearchBarView: View {
    @Bindable var viewModel: SearchBarViewModel
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            ZStack(alignment: .trailing) {
                TextField("", text: $viewModel.query, prompt: searchPrompt)
                    .frame(height: 36)
                    .padding(.horizontal, 36)
                    .background(Color.gray.opacity(0.24))
                    .cornerRadius(10)
                    .focused($isFocused)
                    .foregroundStyle(.white)
                    .font(.manrope(15))
                    .onChange(of: isFocused) { _, newState in
                        viewModel.updateStateOnFocus(newState)
                    }
                    .onChange(of: viewModel.query) { _, _ in
                        viewModel.updateStateOnQueryChange(isFocused)
                    }
                
                searchOverlay
            }
            
            if viewModel.isActive() {
                Button("Cancel") {
                    viewModel.switchSearchState(.inactive)
                    isFocused = false
                }
                .font(.manrope(15))
                .foregroundColor(.white)
                .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity.animation(.easeInOut(duration: 1))), removal: .move(edge: .trailing).combined(with: .opacity.animation(.easeInOut(duration: 0.1)))))
            }
        }
        .animation(.default, value: viewModel.state)
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
            
            if viewModel.isActive() {
                Button(action: viewModel.clearQuery) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.gray)
                }
                .padding(.trailing, 10)
                .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity.animation(.easeInOut(duration: 1))), removal: .move(edge: .trailing).combined(with: .opacity.animation(.easeInOut(duration: 0.1)))))
            }
        }
    }
}

// MARK: - ViewModel

@Observable
class SearchBarViewModel {
    var query: String = ""
    var state: SearchState = .inactive
    
    func clearQuery() {
        query = ""
    }
    
    func switchSearchState(_ state: SearchState) {
        self.state = state
        if state == .inactive {
            clearQuery()
        }
    }
    
    func isActive() -> Bool {
        return state == .active
    }
    
    func updateStateOnFocus(_ isFocused: Bool) {
        if isFocused {
            state = .active
        }
    }
    
    func updateStateOnQueryChange(_ isFocused: Bool) {
        state = query.isEmpty && !isFocused ? .inactive : .active
    }
}

// MARK: - Preview

#Preview {
    struct PreviewWrapper: View {
        @State private var viewModel = SearchBarViewModel()
        
        var body: some View {
            VStack {
                SearchBarView(viewModel: viewModel)
                    .padding()
                Spacer()
            }
            .background(Color.black)
        }
    }
    return PreviewWrapper()
}
