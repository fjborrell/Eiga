//
//  ExploreView.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/20/24.
//

import SwiftUI

struct ExploreView: View {
    var jjk: some View {
        Image("jjk")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 370, height: 170)
    }
    
    var body: some View {
        VStack {
            Image(systemName: "circle.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundStyle(.white)
            
            ExploreBarView()
                .padding(.vertical, 10)
                
            BlockView(title: "Featured") { _ in
                jjk
            }
            
            BlockView(title: "Explore Block", isFilterable: true) { block in
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

#Preview {
    ExploreView()
}