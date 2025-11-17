//
//  Assignment2App.swift
//  Assignment2
//
//  Created by  Amal Allaham on 2025-11-14.
//

import SwiftUI
@main
struct Assignment2App: App {
    @StateObject var session = SessionManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(session)

        }
    }
}

