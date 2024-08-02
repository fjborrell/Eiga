//
//  SearchTriggerView.swift
//  Eiga
//
//  Created by Fernando Borrell on 8/1/24.
//

import SwiftUI

struct SearchTriggerView: View {
    @Binding var isExpanded: Bool
    
    private let backgroundColor: Color = .black.opacity(0.6)
    private let overlayColor: Color = .white.opacity(0.75)
    
    var tapHandler: () -> Void = {}
    
    var body: some View {
        Group {
            if isExpanded {
                expandedView
            } else {
                collapsedView
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: tapHandler)
        .transition(.blurReplace)
    }
    
    private var expandedView: some View {
        HStack {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(backgroundColor)
                    .frame(height: 36)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(overlayColor)
                    
                    Text("Search")
                        .foregroundColor(overlayColor.opacity(0.7))
                        .font(.manrope(15))
                }
                .padding(.leading, 10)
            }
        }
        .padding(.horizontal)
    }
    
    private var collapsedView: some View {
        Image(systemName: "magnifyingglass.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .symbolRenderingMode(.palette)
            .foregroundStyle(.white, .pink)
            .frame(width: 36, height: 36)
            .opacity(0.9)
    }
}

struct SearchTriggerPreview: View {
    @State private var isExpanded = false
    
    var body: some View {
        VStack {
            SearchTriggerView(isExpanded: $isExpanded)
                .padding()
            
            Toggle("Expanded", isOn: $isExpanded)
                .padding()
        }
        .background(Color.gray)
    }
}

#Preview {
    SearchTriggerPreview()
}
