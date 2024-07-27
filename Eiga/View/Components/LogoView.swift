//
//  LogoView.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/26/24.
//

import Foundation
import SwiftUI

struct LogoView: View {
    var body: some View {
        Image("logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 40)
            .foregroundStyle(.white)
    }
}

#Preview {
    LogoView()
        .hueBackground(hueColor: .pink)
}
