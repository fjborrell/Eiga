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
    private let backgroundColor: Color = .black.opacity(0.6)
    @Bindable var viewModel: SearchBarViewModel
    @FocusState private var isFocused: Bool
    @Binding var isCollapsed: Bool
    
    var body: some View {
        ZStack {
            if isCollapsed {
                collapsed
                    .transition(.scale(scale: 0.0).combined(with: .opacity))
            } else {
                expandedView
                    .transition(.scale(scale: 0.0).combined(with: .opacity))
            }
        }
        .animation(.smooth(duration: 0.15, extraBounce: -0.2), value: isCollapsed)
    }
    
    private var expandedView: some View {
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
                        if newValue {
                            withAnimation {
                                isCollapsed = false
                            }
                        }
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
        .buttonStyle(.plain)
        .transition(.opacity.animation(.easeInOut(duration: 0.1)))
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            withAnimation {
                viewModel.cancel()
                isFocused = false
                //isCollapsed = true // Recollapse on cancel ?
            }
        }
        .font(.manrope(15))
        .foregroundColor(.white)
        .transition(.move(edge: .trailing).combined(with: .opacity))
    }
    
    private var collapsed: some View {
        Button(action: {
            withAnimation {
                isCollapsed = false
                viewModel.expand()
                isFocused = true
            }
        }, label: {
            Image(systemName: "magnifyingglass.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .pink)
                .frame(width: 40, height: 40)
                .opacity(0.9)
        })
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
    
    func expand() {
        isActive = true
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

//MARK: - Preview

#Preview {
    struct PreviewWrapper: View {
        @State private var viewModel = SearchBarViewModel()
        @State private var isCollapsed = false
        
        var body: some View {
            VStack {
                SearchBarView(viewModel: viewModel, isCollapsed: $isCollapsed)
                    .padding()
                    .padding(.top, 50)
                
                Toggle("Collapsed", isOn: $isCollapsed)
                    .padding()
                    .onChange(of: isCollapsed) { _, newValue in
                        withAnimation {
                            if newValue {
                                viewModel.cancel()
                            } else {
                                viewModel.expand()
                            }
                        }
                    }
                
                Spacer()
            }
            .hueBackground(hueColor: .pink)
        }
    }
    return PreviewWrapper()
}
