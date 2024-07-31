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
