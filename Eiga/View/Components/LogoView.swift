//
//  LogoView.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/26/24.
//

import Foundation
import SwiftUI

/// A view that displays the app's logo.
struct LogoView: View {
    // MARK: - Body
    
    var body: some View {
        Image("logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 40)
            .foregroundStyle(.white)
    }
}

// MARK: - Preview

#Preview {
    LogoView()
        .hueBackground(hueColor: .pink)
}
