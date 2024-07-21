//
//  UIBlock.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/16/24.
//

import SwiftUI

// MARK: - Main View
struct BlockView<Content: View>: View {
    private let title: String
    private let isFilterable: Bool
    @Binding private var selectedFilter: ExploreFilter
    private let content: ((ExploreFilter) -> Content)?
    private let staticContent: Content?
    
    // Initializer for filterable block
    init(
        title: String,
        selectedFilter: Binding<ExploreFilter>,
        @ViewBuilder content: @escaping (ExploreFilter) -> Content
    ) {
        self.title = title
        self.isFilterable = true
        self._selectedFilter = selectedFilter
        self.content = content
        self.staticContent = nil
    }
    
    // Initializer for non-filterable block
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.isFilterable = false
        self._selectedFilter = .constant(.popular) // Dummy binding
        self.content = nil
        self.staticContent = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if isFilterable {
                filterableTitle
            } else {
                BlockLabel(title: title)
            }
            
            if isFilterable {
                content?(selectedFilter)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            } else {
                staticContent
            }
        }
        .animation(.easeInOut, value: selectedFilter)
    }
    
    private var filterableTitle: some View {
        Menu {
            Picker("Filter", selection: $selectedFilter) {
                ForEach(ExploreFilter.allCases) { filter in
                    Text(filter.title).tag(filter)
                }
            }
        } label: {
            BlockLabel(title: selectedFilter.title, isFilterable: true)
        }
    }
}

// MARK: - Supporting Views
struct BlockLabel: View {
    let title: String
    var isFilterable: Bool = false
    
    var body: some View {
        HStack(spacing: 8) {
            if isFilterable {
                Image(systemName: "chevron.up.chevron.down")
                    .imageScale(.small)
            }
            Text(title)
                .font(.manrope(20, .semiBold))
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
        }
        .foregroundColor(.white)
    }
}

// MARK: - Previews
#Preview("BlockView Examples") {
    struct PreviewWrapper: View {
        @State private var testFilter: ExploreFilter = .popular
        
        var body: some View {
            ZStack {
                Color.gray.ignoresSafeArea()
                VStack(alignment: .leading, spacing: 20) {
                    // Non-filterable block
                    BlockView(title: "Static Block") {
                        Text("This is a block with a static title")
                            .padding()
                            .background(Color.secondary.opacity(0.5))
                            .cornerRadius(8)
                    }
                    
                    // Filterable block
                    BlockView(
                        title: "Filterable Block",
                        selectedFilter: $testFilter
                    ) { filter in
                        VStack(alignment: .leading) {
                            Text("Selected filter: \(filter.title)")
                            Text("This content changes based on the selected filter")
                                .font(.caption)
                        }
                        .padding()
                        .background(Color.blue.opacity(0.5))
                        .cornerRadius(8)
                    }
                }
                .padding()
            }
        }
    }
    
    return PreviewWrapper()
}
