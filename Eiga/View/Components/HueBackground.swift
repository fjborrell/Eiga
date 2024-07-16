//
//  HueBackground.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/16/24.
//

import Foundation
import SwiftUI

struct HueBackground: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                // Grayscale Gradient
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                .black,
                                .onyx
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                // Colored Hue
                Ellipse()
                    .fill(
                        LinearGradient(
                            colors: [
                                .pink.opacity(0.4),
                                .clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .position(x: geometry.size.width / 2, y: 0) // Center the hue
                    .offset(y: -geometry.size.height * 0.2) // Raise to top Xth of screen
                    .frame(
                        width: geometry.size.width * 1.5, // Widen factor
                        height: geometry.size.height * 0.5 // Stretch factor
                    )
                    .blur(radius: 40)
            }
            .ignoresSafeArea(.all)
        }
        
    }
}

#Preview {
    HueBackground()
}
