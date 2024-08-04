//
//  UIBlock.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/16/24.

import SwiftUI

// MARK: - Model

/// A protocol that defines the structure for a block view in the UI.
protocol BlockView: View {
    /// The title of the block.
    var title: String { get }
    
    /// The associated type for the content of the block.
    associatedtype Content: View
    
    /// The content of the block.
    var content: Content { get }
}

// MARK: - Static Block

/// A view that represents a static block with a title and content.
struct StaticBlock<Content: View>: BlockView {
    let title: String
    let content: Content
    
    /// Initializes a new static block.
    /// - Parameters:
    ///   - title: The title of the block.
    ///   - content: A closure that returns the content of the block.
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            BlockLabel(title: title)
            content
        }
    }
}

// MARK: - Dynamic Block

/// A view that represents a dynamic block with a title, filter, and content that changes based on the selected filter.
struct DynamicBlock<Content: View, Filter: FilterOption>: BlockView {
    let title: String
    @Binding var selectedFilter: Filter?
    let content: Content
    
    /// Initializes a new dynamic block.
    /// - Parameters:
    ///   - title: The title of the block.
    ///   - selectedFilter: A binding to the currently selected filter.
    ///   - content: A closure that returns the content of the block based on the selected filter.
    init(
        title: String,
        selectedFilter: Binding<Filter?>,
        @ViewBuilder content: @escaping (Filter?) -> Content
    ) {
        self.title = title
        self._selectedFilter = selectedFilter
        self.content = content(selectedFilter.wrappedValue)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title with filter menu
            Menu {
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(Array(Filter.allCases), id: \.self) { filter in
                        Text(filter.title).tag(filter as Filter?)
                    }
                }
            } label: {
                BlockLabel(title: selectedFilter?.title ?? title, isFilterable: true)
            }
            
            content
        }
        .animation(.smooth(duration: 0.2), value: selectedFilter)
    }
}

// MARK: - Block Label

/// A view that displays the label for a block, optionally showing a filter indicator.
struct BlockLabel: View {
    let title: String
    var isFilterable: Bool = false
    
    var body: some View {
        HStack {
            Label {
                Text(title)
                    .font(.manrope(20, .semiBold))
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            } icon: {
                if isFilterable {
                    Image(systemName: "chevron.up.chevron.down")
                        .imageScale(.small)
                }
            }
            .foregroundColor(.white)
            
            Spacer()
        }
    }
}

// MARK: - Previews

#Preview {
    struct PreviewWrapper: View {
        @State private var testFilter: ExploreFilter? = .popular
        
        var body: some View {
            ZStack {
                Color.gray.ignoresSafeArea()
                VStack(alignment: .leading, spacing: 20) {
                    staticBlockPreview
                    filterableBlockPreview
                }
                .padding()
            }
        }
        
        /// A preview of a static block.
        var staticBlockPreview: some View {
            StaticBlock(title: "Static Block") {
                Text("This is a static block")
                    .padding()
                    .background(Color.secondary.opacity(0.5))
                    .cornerRadius(8)
            }
        }
        
        /// A preview of a dynamic block with a filter.
        var filterableBlockPreview: some View {
            DynamicBlock(
                title: "Dynamic Block",
                selectedFilter: $testFilter
            ) { filter in
                VStack(alignment: .leading) {
                    Text("Selected filter: \(filter?.title ?? "None")")
                    Text("This content changes based on the selected filter")
                        .font(.caption)
                }
                .padding()
                .background(Color.blue.opacity(0.5))
                .cornerRadius(8)
            }
        }
    }
    
    return PreviewWrapper()
}
