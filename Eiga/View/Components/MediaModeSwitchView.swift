//
//  MediaModeSwitcherView.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/16/24.
//

import Foundation
import SwiftUI

struct MediaModeSwitchView: View {
    @Environment(AppState.self) private var appState: AppState
    
    var body: some View {
        @Bindable var appState = appState
        withAnimation(.interactiveSpring) {
            Menu {
                Picker("Media Mode", selection: $appState.selectedMediaMode) {
                    ForEach(MediaMode.allCases, id: \.self) { mode in
                        Text(mode.title).tag(mode)
                    }
                }
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 36, height: 36)
                    .opacity(0.24)
                    .overlay(
                        Image(systemName: self.appState.selectedMediaMode.iconName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 23, height: 20)
                    )
                    .foregroundStyle(self.appState.selectedMediaMode.color)
                
            }
            .contentTransition(.symbolEffect(.replace))
        }
    }
}

extension MediaModeSwitchView {
    @Observable
    class MediaModeSwitchViewModel {
        
    }
}

#Preview {
    MediaModeSwitchView()
        .environment(AppState())
}
