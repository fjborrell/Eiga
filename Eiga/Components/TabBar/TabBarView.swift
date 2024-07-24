//
//  Tab.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/18/24.
//

import Foundation
import SwiftUI


struct TabBarView: View {
    @Binding var selectedTab: Tab
    var body: some View {
        ZStack() {
            Rectangle()
                .fill(LinearGradient.tabBar)
            HStack {
                ForEach(Tab.allCases.prefix(2), id: \.self) { tab in
                    TabView(tab: tab, selectedTab: $selectedTab)
                }
                
                AddButton()
                
                ForEach(Tab.allCases.suffix(2), id: \.self) { tab in
                    TabView(tab: tab, selectedTab: $selectedTab)
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 20)
        }
        .frame(width: .infinity, height: 105)
    }
    
    struct AddButton: View {
        @State var animationTrigger: Bool = false
        
        var body: some View {
            Button(action: {
                animationTrigger.toggle()
                // Pull up add sheet!
            }, label: {
                VStack {
                    Image(systemName: "plus.app")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28)
                        .symbolRenderingMode(.hierarchical)
                        .symbolEffect(.bounce, value: animationTrigger)
                        .foregroundStyle(.green)
                    Text("Add")
                        .font(.manrope(12))
                        .foregroundStyle(.white)
                }
            })
            .frame(maxWidth: .infinity)
            .buttonStyle(.plain)
        }
    }
    
    
    struct TabView: View {
        let tab: Tab
        @Binding var selectedTab: Tab
        @State var animationTrigger: Bool = false
        
        var body: some View {
            Button(action: {
                selectedTab = tab
                animationTrigger.toggle()
            }, label: {
                VStack {
                    Image(systemName: tab.iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28)
                        .symbolEffect(.bounce, value: animationTrigger)
                        .foregroundStyle(isSelected() ? .pink : .white)
                    Text(tab.title)
                        .font(.manrope(12))
                        .foregroundStyle(isSelected() ? .pink : .white)
                }
            })
            .frame(maxWidth: .infinity)
            .buttonStyle(.plain)
        }
        
        private func isSelected() -> Bool {
            return selectedTab == tab
        }
    }
}

#Preview {
    VStack {
        Spacer()
        TabBarView(selectedTab: .constant(.explore))
    }
    .ignoresSafeArea()
    .hueBackground(hueColor: .pink)
}
