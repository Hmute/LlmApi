//
//  ContentView.swift
//  TodoListApp
//
//  Created by Mitchell MacDonald on 2025-10-17.
//

import SwiftUI


struct ContentView: View {
    @StateObject var viewModel = ContentViewViewModel()
    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            accountView
        } else {
            LoginView()
        }
    }
    
    @ViewBuilder
    var accountView: some View {
        VStack {
            TabView {
                HomeView(userId: viewModel.currentUserId)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                AIView(userId: viewModel.currentUserId)
                    .tabItem {
                        Label("AI", systemImage: "star.fill")
                    }
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.circle")
                    }
                AboutView()
                    .tabItem {
                        Label("About", systemImage: "info.circle")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
