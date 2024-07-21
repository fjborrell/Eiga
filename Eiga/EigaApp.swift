//
//  EigaApp.swift
//  Eiga
//
//  Created by Fernando Borrell on 6/21/24.
//

import SwiftUI
import SwiftData

@main
struct EigaApp: App {
    @State private var appState: AppState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
        }
    }
}
