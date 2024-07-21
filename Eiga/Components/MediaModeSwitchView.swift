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
        Menu {
            Picker("Media Mode", selection: self.$viewModel.mode) {
                ForEach(MediaMode.allCases, id: \.self) { mode in
                    Text(mode.title).tag(mode)
                }
            }
        } label: {
            switch self.viewModel.mode {
            case .tv:
                createSwitcherLabel(style: .blue, sfIcon: "tv")
            case .movie:
                createSwitcherLabel(style: .red, sfIcon: "popcorn.fill")
            case .all:
                createSwitcherLabel(style: .pink, sfIcon: "play.rectangle.on.rectangle.fill")
            }
            
        }
    }
    
    @ViewBuilder
    private func createSwitcherLabel<T: ShapeStyle>(style: T, sfIcon: String) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: 36, height: 36)
            .opacity(0.24)
            .overlay(
                Image(systemName: sfIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 20)
            )
            .foregroundStyle(style)
    }
}

extension MediaModeSwitchView {
    @Observable
    class MediaModeSwitchViewModel {
        var mode: MediaMode = .all
    }
}

#Preview {
    MediaModeSwitchView()
}
