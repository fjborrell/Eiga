//
//  UIBlock.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/16/24.
//

import Foundation
import SwiftUI

struct UIBlock: View {
    // TODO: Convert UIBlock into a customizable view
    // e.g. UIBlock(viewModel.selectedFilter, filterable: true) { ScrollView() }
    
    
    @State private var viewModel: ViewModel = ViewModel()
    
    var body: some View {
        // Filter
        HStack {
            Menu {
                Picker("Filter", selection: self.$viewModel.selectedFilter) {
                    ForEach(ExploreFilter.allCases, id: \.self) { filter in
                        Text(filter.title).tag(filter)
                    }
                }
            } label: {
                createFilterLabel(title: viewModel.selectedFilter.title)
            }
            .foregroundStyle(.white)
            Spacer()
        }
    }
    
    @ViewBuilder
    private func createFilterLabel(title: String) -> some View {
        HStack() {
            Image(systemName: "chevron.up.chevron.down.square.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 23, height: 23)
                .symbolRenderingMode(.hierarchical)
            Text(title)
                .font(.manrope(20, .semiBold))
        }
    }
}

extension UIBlock {
    @Observable
    class ViewModel {
        var selectedFilter: ExploreFilter = .popular
    }
}

#Preview {
    ZStack {
        Color.gray
        UIBlock()
    }
    .ignoresSafeArea(.all)
}
