//
//  ProfileView.swift
//  TodoListApp
//
//  Created by Mitchell MacDonald on 2025-10-17.
//

import SwiftUI
struct ProfileView: View {
    @EnvironmentObject var session: SessionManager
    @StateObject private var viewModel: ProfileViewViewModel

    init(session: SessionManager) {
        _viewModel = StateObject(wrappedValue: ProfileViewViewModel(session: session))
    }

    var body: some View {
        NavigationStack {
            VStack {
                if let user = viewModel.user {
                    profile(user: user)
                } else if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                    Button("Retry") {
                        viewModel.fetchUser()
                    }
                    .padding()
                } else {
                    ProgressView("Loading profile…")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
            }
            .navigationTitle("Profile")
            .onAppear {
                viewModel.fetchUser() // will see correct session.token
            }
        }
    }

    @ViewBuilder
    func profile(user: User) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 125, height: 125)
                .foregroundColor(.blue)
                .padding()

            VStack(alignment: .leading, spacing: 10) {
                HStack { Text("Name:").bold(); Text("\(user.firstName) \(user.lastName)") }
                HStack { Text("Email:").bold(); Text(user.email) }
                HStack {
                        Text("Member since:").bold()
                        Text(user.accountCreationDate.formatted(date: .abbreviated, time: .shortened))
                    }
                HStack {
                        Text("Last login:").bold()
                        Text(user.lastLoginDate.formatted(date: .abbreviated, time: .shortened))
                    }
                
            }
            .padding()

            Button("Logout") {
                viewModel.logout()
            }
            .tint(.red)
            .padding()
        }
    }
}
