//
//  SearchBarView.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/15/24.
//

import Foundation
import SwiftUI

// MARK: - View

struct SearchBarView: View {
    private let overlayColor: Color = .white.opacity(0.75)
    private let backgroundColor: Color = .black.opacity(0.45)
    @Bindable var viewModel: SearchBarViewModel
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            ZStack(alignment: .trailing) {
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
                
                searchOverlay
            }
            
            if viewModel.isActive {
                Button("Cancel") {
                    viewModel.setInactive()
                    isFocused = false
                }
                .font(.manrope(15))
                .foregroundColor(.white)
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity.animation(.easeInOut(duration: 0.7))),
                        removal: .move(edge: .trailing).combined(with: .opacity.animation(.easeInOut(duration: 0.2)))
                    )
                )
            }
        }
        .animation(.default, value: viewModel.isActive)
    }
    
    private var searchPrompt: Text {
        Text("Search")
            .font(.manrope(15))
            .foregroundStyle(overlayColor.opacity(0.6))
    }
    
    private var searchOverlay: some View {
        HStack {
            // ICON
            Image(systemName: "magnifyingglass")
                .imageScale(.medium)
                .foregroundStyle(overlayColor)
                .padding(.leading, 10)
                .onTapGesture {
                    isFocused = true
                }
            
            Spacer()
            
            // CLEAR QUERY 'X'
            if !viewModel.query.isEmpty {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.clearQuery()
                    }
                    isFocused = true
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(overlayColor)
                }
                .padding(.trailing, 10)
                .transition(
                    .asymmetric(
                        insertion: .opacity.animation(.easeInOut(duration: 0.3)),
                        removal: .identity
                    )
                )
            }
        }
    }
}

// MARK: - ViewModel

@Observable
class SearchBarViewModel {
    var query: String = ""
    var isActive: Bool = false
    
    func clearQuery() {
        query = ""
        updateStateOnQueryChange(query)
    }
    
    func setActive(_ value: Bool) {
        isActive = value
    }
    
    func setInactive() {
        isActive = false
        clearQuery()
    }
    
    func updateStateOnQueryChange(_ newQuery: String) {
        isActive = !newQuery.isEmpty || isActive
    }
    
    func updateStateOnFocusChange(_ isFocused: Bool) {
        isActive = isFocused || !query.isEmpty
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
                    .padding(.top, 50)
                Spacer()
            }
            .hueBackground(hueColor: .pink)
        }
    }
    return PreviewWrapper()
}
