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
    var jjk: some View {
        Image("jjk")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 180)
    }
    
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
                Block(title: "Explore Block", isFilterable: true) { block in
                    ScrollView {
                        if block.selectedFilter == .popular {
                            jjk.colorInvert()
                        } else {
                            jjk
                        }
                    }
                }
            }
            
        }
    }
}

#Preview {
    ContentView()
}
