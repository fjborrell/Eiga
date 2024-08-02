//
//  SearchBarView.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/15/24.
//

import Foundation
import SwiftUI

/// A custom search bar view with dynamic behavior.
struct SearchBarView: View {
    // MARK: - Constants
    
    private let overlayColor: Color = .white.opacity(0.8)
    private let backgroundColor: Color = .black.opacity(0.8)
    
    // MARK: - Properties
    
    @Bindable var viewModel: SearchBarViewModel
    @FocusState private var isFocused: Bool
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 10) {
            ZStack(alignment: .trailing) {
                searchTextField
                searchOverlay
            }
            
            if viewModel.isActive {
                cancelButton
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.isActive)
    }
    
    // MARK: - Subviews
    
    /// The main search text field.
    private var searchTextField: some View {
        TextField("", text: $viewModel.query, prompt: searchPrompt)
            .frame(height: 36)
            .padding(.leading, 36)
            .background(backgroundColor)
            .cornerRadius(10)
            .foregroundStyle(.white)
            .font(.manrope(15))
            .focused($isFocused)
            .onChange(of: viewModel.query) { _, newQuery in
                viewModel.updateStateOnQueryChange(newQuery)
            }
            .onChange(of: isFocused) { _, newValue in
                viewModel.updateStateOnFocusChange(newValue)
            }
    }
    
    /// The prompt text for the search field.
    private var searchPrompt: Text {
        Text("Search")
            .font(.manrope(15))
            .foregroundStyle(overlayColor.opacity(0.7))
    }
    
    /// The overlay view containing the search icon and clear button.
    private var searchOverlay: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .imageScale(.medium)
                .foregroundStyle(overlayColor)
                .padding(.leading, 10)
                .onTapGesture {
                    isFocused = true
                }
            
            Spacer()
            
            if !viewModel.query.isEmpty {
                clearButton
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.query.isEmpty)
    }
    
    /// The clear button to reset the search query.
    private var clearButton: some View {
        Button(action: {
            viewModel.clearQuery()
            isFocused = true
        }) {
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(overlayColor)
        }
        .padding(.trailing, 10)
        .transition(.opacity.animation(.easeInOut(duration: 0.1)))
    }
    
    /// The cancel button to dismiss the search bar.
    private var cancelButton: some View {
        Button("Cancel") {
            viewModel.cancel()
            isFocused = false
        }
        .font(.manrope(15))
        .foregroundColor(.white)
        .transition(.move(edge: .trailing).combined(with: .opacity))
    }
}

/// View model for managing the search bar state.
@Observable
class SearchBarViewModel {
    // MARK: - Properties
    
    var query: String = ""
    var isActive: Bool = false
    
    // MARK: - Methods
    
    /// Clears the search query and updates the state.
    func clearQuery() {
        query = ""
        updateStateOnQueryChange(query)
    }
    
    /// Cancels the search, clearing the query and deactivating the search bar.
    func cancel() {
        isActive = false
        clearQuery()
    }
    
    /// Updates the state based on changes to the search query.
    /// - Parameter newQuery: The new search query string.
    func updateStateOnQueryChange(_ newQuery: String) {
        isActive = !newQuery.isEmpty || isActive
    }
    
    /// Updates the state based on changes to the focus state of the search field.
    /// - Parameter isFocused: Whether the search field is focused.
    func updateStateOnFocusChange(_ isFocused: Bool) {
        isActive = isFocused || !query.isEmpty
    }
}

// MARK: - Preview

#Preview {
    SearchBarView(viewModel: SearchBarViewModel())
        .padding()
        .background(Color.gray)
}
