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
                cancelButton
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.isActive)
    }
    
    private var searchPrompt: Text {
        Text("Search")
            .font(.manrope(15))
            .foregroundStyle(overlayColor.opacity(0.7))
    }
    
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

@Observable
class SearchBarViewModel {
    var query: String = ""
    var isActive: Bool = false
    
    func clearQuery() {
        query = ""
        updateStateOnQueryChange(query)
    }
    
    func cancel() {
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

#Preview {
    SearchBarView(viewModel: SearchBarViewModel())
        .padding()
        .background(Color.gray)
}
