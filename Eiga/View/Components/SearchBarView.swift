//
//  SearchBarView.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/15/24.
//

import Foundation
import SwiftUI

struct SearchBarView: View {
    @State private var viewModel: ViewModel = ViewModel()
    @FocusState var isFocused: Bool
    
    var body: some View {
        TextField("", text: $viewModel.query)
            .frame(minWidth: 220, maxWidth: 320, minHeight: 36, maxHeight: 36)
            .padding(.horizontal, 14)
            .background(
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(.gray.secondary)
                    .opacity(0.24)
            )
            .overlay(placeholder())
            .focused($isFocused)
    }
    
    @ViewBuilder
    private func placeholder() -> some View {
        if viewModel.isEmpty && !isFocused {
            HStack {
                Label(title: {
                    Text("Search")
                        .font(.manrope(15, .regular))
                }, icon: {
                    Image(systemName: "magnifyingglass")
                })
                .padding(.leading)
                .foregroundStyle(.gray)
                Spacer()
            }
        }
    }
}

extension SearchBarView {
    @Observable
    class ViewModel {
        var query: String = ""
        var isEmpty: Bool {
            query.isEmpty
        }
    }
}

#Preview {
    SearchBarView()
}
