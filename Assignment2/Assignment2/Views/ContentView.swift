//
//  ContentView.swift
//  Assignment 2
//
//  Created by Amal Allaham on 2025-11-16.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewViewModel()
    @EnvironmentObject var session: SessionManager

    
    var body: some View {
        Group {
            if session.isSignedIn {
                accountView
            } else {
                LoginView()
            }
        }
        .onAppear {
            session.loadSession()
        }
    }
    
    @ViewBuilder
    var accountView: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            AIView(userId: viewModel.currentUserEmail)
                .tabItem {
                    Label("AI", systemImage: "star.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
    }
}

#Preview {
    ContentView()
}
