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
    // MARK: - State
    
    /// The global state of the application.
    @State private var appState: AppState = AppState()
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
        }
    }
}
