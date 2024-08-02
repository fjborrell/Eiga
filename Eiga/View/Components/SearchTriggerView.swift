//
//  SearchTriggerView.swift
//  Eiga
//
//  Created by Fernando Borrell on 8/1/24.
//

import SwiftUI

struct SearchTriggerView: View {
    @Binding var isCollapsed: Bool
    
    private let backgroundColor: Color = .black.opacity(0.8)
    private let overlayColor: Color = .white.opacity(0.8)
    
    var tapHandler: () -> Void = {}
    
    var body: some View {
        Button(action: tapHandler, label: {
            Group {
                if isCollapsed {
                    collapsedView
                } else {
                    expandedView
                }
            }
            .transition(.blurReplace().animation(.easeInOut(duration: 0.15)))
        })
        .buttonStyle(.plain)
        
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
    @State private var isCollapsed = false
    
    var body: some View {
        VStack {
            SearchTriggerView(isCollapsed: $isCollapsed) {
                print("Action")
            }
                .padding()
            
            Toggle("Expanded", isOn: $isCollapsed)
                .padding()
        }
        .background(Color.gray)
    }
}

#Preview {
    SearchTriggerPreview()
}
