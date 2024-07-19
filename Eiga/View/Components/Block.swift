//
//  UIBlock.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/16/24.
//

import Foundation
import SwiftUI

struct Block<Content: View>: View {
    @State private var viewModel: BlockViewModel
    let content: (BlockViewModel) -> Content
    
    init(
        title: String,
        isFilterable: Bool = false,
        initialFilter: ExploreFilter = ExploreFilter.allCases.first ?? .popular,
        content: @escaping (BlockViewModel) -> Content
    ) {
        _viewModel = State(initialValue: BlockViewModel(title: title, isFilterable: isFilterable, selectedFilter: initialFilter))
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if viewModel.isFilterable {
                filterableTitle
            } else {
                staticTitle
            }
            
            content(viewModel)
        }
    }
    
    private var filterableTitle: some View {
        Menu {
            Picker("Filter", selection: $viewModel.selectedFilter) {
                ForEach(ExploreFilter.allCases, id: \.self) { filter in
                    Text(filter.title).tag(filter)
                }
            }
        } label: {
            BlockLabel(title: viewModel.selectedFilter.title, isFilterable: true)
        }
        .foregroundStyle(.white)
    }
    
    private var staticTitle: some View {
        BlockLabel(title: viewModel.title, isFilterable: false)
            .foregroundStyle(.white)
    }
}

struct BlockLabel: View {
    let title: String
    let isFilterable: Bool
    
    var body: some View {
        HStack {
            if isFilterable {
                Image(systemName: "chevron.up.chevron.down.square.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 23)
                    .symbolRenderingMode(.hierarchical)
            }
            Text(title)
                .font(.custom("Manrope-SemiBold", size: 20))
        }
    }
}

@Observable
class BlockViewModel {
    var title: String
    var isFilterable: Bool
    var selectedFilter: ExploreFilter
    
    init(title: String, isFilterable: Bool, selectedFilter: ExploreFilter) {
        self.title = title
        self.isFilterable = isFilterable
        self.selectedFilter = selectedFilter
    }
}

#Preview {
    ZStack {
        Color.gray
        VStack(spacing: 20) {
            Block(title: "Static Block") { _ in
                Text("This is a block with a static title")
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            
            Block(title: "Filterable Block", isFilterable: true) { viewModel in
                VStack(alignment: .leading) {
                    Text("Selected filter: \(viewModel.selectedFilter.title)")
                    Text("This content changes based on the selected filter")
                        .font(.caption)
                }
                .padding()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(8)
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
