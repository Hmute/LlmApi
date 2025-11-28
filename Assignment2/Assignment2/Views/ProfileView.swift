//
//  ProfileView.swift
//  Assignment2
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var session: SessionManager
    @StateObject private var viewModel = ProfileViewViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                
                // USER LOADED
                if let user = viewModel.user {
                    profile(user: user)
                
                // ERROR STATE
                } else if !viewModel.errorMessage.isEmpty {
                    Text("Error: \(viewModel.errorMessage)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()

                    Button("Retry") {
                        viewModel.fetchUser()
                    }
                    .padding()

                // LOADING STATE
                } else {
                    ProgressView("Loading profile…")
                        .padding()
                }
            }
            .navigationTitle("Profile")
            .onAppear {
                // Attach real environment session to ViewModel
                viewModel.attachSession(session)
                viewModel.fetchUser()
            }
        }
    }

    // MARK: - Profile UI
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
                    if let last = user.lastLoginDate {
                        Text(last.formatted(date: .abbreviated, time: .shortened))
                    } else {
                        Text("Never")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()

            Button("Logout") {
                viewModel.logout()
            }
            .foregroundColor(.red)
            .padding()
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(SessionManager())
}
