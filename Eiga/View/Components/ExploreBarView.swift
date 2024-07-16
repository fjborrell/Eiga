//
//  ExploreBar.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/16/24.
//

import SwiftUI

struct ExploreBarView: View {
    var body: some View {
        HStack {
            MediaModeSwitcherView()
            SearchBarView()
        }
    }
}

#Preview {
    ExploreBarView()
}
