//
//  UIKitWrappers.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/31/24.
//

import UIKit
import SwiftUI

struct CustomBlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct RoundedBlurBackground: ViewModifier {
    let style: UIBlurEffect.Style
    let padding: CGFloat
    let opacity: CGFloat
    let radius: CGFloat
    func body(content: Content) -> some View {
        ZStack (alignment: .center) {
            content
                .padding(self.padding)
                .background {
                    CustomBlurView(style: self.style)
                        .clipShape (
                            RoundedRectangle(cornerRadius: radius)
                        )
                        .opacity(self.opacity)
                }
        }
    }
}

extension View {
    func roundedBlurBackground(
        style: UIBlurEffect.Style,
        padding: CGFloat = 10,
        opacity: CGFloat = 1.0,
        radius: CGFloat = 16
    ) -> some View {
        modifier(RoundedBlurBackground(style: style, padding: padding, opacity: opacity, radius: radius))
    }
}
