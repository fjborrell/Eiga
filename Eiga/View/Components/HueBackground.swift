//
//  HueBackground.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/16/24.
//

import Foundation
import SwiftUI

struct HueBackground: ViewModifier {
    var hueColor: Color
    func body(content: Content) -> some View {
        ZStack {
            GeometryReader { geometry in
                ZStack(alignment: .center) {
                    // Grayscale Gradient
                    Rectangle()
                        .fill(.black)
                    
                    // Colored Hue
                    Ellipse()
                        .fill(
                            LinearGradient(
                                colors: [
                                    hueColor.opacity(0.85),
                                    .clear
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .position(x: geometry.size.width / 2, y: 0) // Center the hue
                        .offset(y: -geometry.size.height * 0.25) // Raise to top Xth of screen
                        .frame(
                            width: geometry.size.width * 1.5, // Widen factor
                            height: geometry.size.height * 0.4 // Vertical Stretch
                        )
                        .blur(radius: 40)
                        .animation(.smooth, value: hueColor)
                }
            }
            .ignoresSafeArea(.all)
            
            content
        }
        
    }
}

extension View {
    func hueBackground(hueColor: Color) -> some View {
        modifier(HueBackground(hueColor: hueColor))
    }
}

#Preview {
    ZStack() {
        
    }
        .hueBackground(hueColor: .pink)
}