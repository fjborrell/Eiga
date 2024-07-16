//
//  ContentView.swift
//  Eiga
//
//  Created by Fernando Borrell on 6/21/24.
//

import Foundation
import SwiftUI
import SwiftData

struct ContentView: View {
    @State var searchQuery: String = String()
    var body: some View {
        NavigationStack() {
            Image(systemName: "circle.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            UISection()
        }
    }
}

struct UISection: View {
    var body: some View {
        VStack() {
            Text("Popular")
                .font(.manrope(20, .semiBold))
            ScrollView(.vertical) {
                Rectangle()
                    .frame(width: 120, height: 200)
                    .foregroundStyle(.placeholder)
            }
        }
    }
}

#Preview {
    ContentView(searchQuery: "Test")
}
