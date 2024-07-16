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
    var body: some View {
        ZStack() {
            HueBackground()
            VStack {
                Image(systemName: "circle.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.white)
                ExploreBarView()
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                UISection()
            }
            
        }
    }
}

struct UISection: View {
    var body: some View {
        VStack() {
            Text("Popular")
                .font(.manrope(20, .semiBold))
                .foregroundStyle(.white)
            ScrollView(.vertical) {
                Rectangle()
                    .frame(width: 120, height: 200)
                    .foregroundStyle(.placeholder)
            }
        }
    }
}

#Preview {
    ContentView()
}
