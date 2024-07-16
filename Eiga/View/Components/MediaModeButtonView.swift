//
//  MediaModeButtonView.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/16/24.
//

import Foundation
import SwiftUI

struct MediaModeButtonView: View {
    @State private var viewModel: ViewModel = ViewModel()
    
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
                createButtonLabel(style: .blue, sfIcon: "tv")
            case .movie:
                createButtonLabel(style: .red, sfIcon: "popcorn.fill")
            case .all:
                createButtonLabel(style: .pink, sfIcon: "play.rectangle.on.rectangle.fill")
            }
            
        }
    }
    
    @ViewBuilder
    private func createButtonLabel<T: ShapeStyle>(style: T, sfIcon: String) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: 37, height: 37)
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

extension MediaModeButtonView {
    @Observable
    class ViewModel {
        var mode: MediaMode = .all
    }
}

#Preview {
    MediaModeButtonView()
}
