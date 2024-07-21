//
//  MediaModeSwitcherView.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/16/24.
//

import Foundation
import SwiftUI

struct MediaModeSwitchView: View {
    @State private var viewModel: MediaModeSwitchViewModel = MediaModeSwitchViewModel()
    
    var body: some View {
        withAnimation(.interactiveSpring) {
            Menu {
                Picker("Media Mode", selection: self.$viewModel.selectedMode) {
                    ForEach(MediaMode.allCases, id: \.self) { mode in
                        Text(mode.title).tag(mode)
                    }
                }
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 36, height: 36)
                    .opacity(0.24)
                    .overlay(
                        Image(systemName: self.viewModel.selectedMode.iconName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 23, height: 20)
                    )
                    .foregroundStyle(self.viewModel.selectedMode.color)
                
            }
            .contentTransition(.symbolEffect(.replace))
        }
    }
}

extension MediaModeSwitchView {
    @Observable
    class MediaModeSwitchViewModel {
        var selectedMode: MediaMode = .all
    }
}

#Preview {
    MediaModeSwitchView()
}
