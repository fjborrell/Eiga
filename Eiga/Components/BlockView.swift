//
//  UIBlock.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/16/24.


import SwiftUI

// MARK: - Model

protocol BlockView: View {
    var title: String { get }
    associatedtype Content: View
    var content: Content { get }
}

// MARK: - StaticBlock

struct StaticBlock<Content: View>: BlockView {
    let title: String
    let content: Content
    
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

// MARK: - DynamicBlock

struct DynamicBlock<Content: View, Filter: FilterOption>: BlockView {
    let title: String
    @Binding var selectedFilter: Filter?
    let content: Content
    
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
            // Title
            Menu {
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(Array(Filter.allCases), id: \.self) { filter in
                        Text(filter.title).tag(filter as Filter?)
                    }
                }
            } label: {
                BlockLabel(title: selectedFilter?.title ?? title, isFilterable: true)
            }
            
            // Content
            content
                .transition(.asymmetric(
                    insertion: .move(edge: .top).combined(with: .opacity),
                    removal: .move(edge: .bottom).combined(with: .opacity)
                ))
        }
        .animation(.easeInOut, value: selectedFilter)
    }
}

// MARK: - BlockLabel
struct BlockLabel: View {
    let title: String
    var isFilterable: Bool = false
    
    var body: some View {
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
        
        var staticBlockPreview: some View {
            StaticBlock(title: "Static Block") {
                Text("This is a static block")
                    .padding()
                    .background(Color.secondary.opacity(0.5))
                    .cornerRadius(8)
            }
        }
        
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
