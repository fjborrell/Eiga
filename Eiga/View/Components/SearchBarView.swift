//
//  SearchBarView.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/15/24.
//

import Foundation
import SwiftUI

struct SearchBarView: View {
    @State var query: String = String()
    var body: some View {
        TextField("", text: $query)
            .frame(width: 320, height: 36)
            .padding(.horizontal, 14)
            .background(
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(.gray.secondary)
                    .opacity(0.24)
            )
            .overlay(
                HStack() {
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
            )
    }
}

#Preview {
    SearchBarView()
}
