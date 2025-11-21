//
//  RegisterView.swift
//  Assignment 2
//
//  Created by Amal Allaham on 2025-10-17.
//
import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewViewModel()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var session: SessionManager

    var body: some View {
        NavigationStack { // ✅ required for navigation consistency
            ZStack {
                // Background gradient (green-teal vibe)
                LinearGradient(colors: [.green, .teal], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    // Header
                    HeaderView(
                        title: "Assignment 2",
                        subtitle: "Join us!",
                        backgroundGradient: LinearGradient(
                            colors: [.green, .teal],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 200)
                    .padding(.bottom, 20)


                    // Form card
                    VStack(spacing: 16) {
                        if !viewModel.errMsg.isEmpty {
                            Text(viewModel.errMsg)
                                .foregroundColor(.red)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                        }

                        TextField("First Name", text: $viewModel.firstName)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                            .autocorrectionDisabled()

                        TextField("Last Name", text: $viewModel.lastName)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                            .autocorrectionDisabled()

                        TextField("Email", text: $viewModel.email)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()

                        SecureField("Password", text: $viewModel.password)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)

                        Button(action: {
                            Task {
                                if let auth = await viewModel.register(),
                                   viewModel.registrationSuccess {
                                    session.saveSession(token: auth.token, email: auth.email)
                                    await MainActor.run { dismiss() }
                                }
                            }
                        }) {
                            Text("Create Account")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(LinearGradient(colors: [.mint, .green], startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(15)
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                        }

                    }
                    .padding(24)
                    .background(.ultraThinMaterial)
                    .cornerRadius(25)
                    .padding(.horizontal)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    .offset(y: -50)

                    Spacer()
                }
            }
        }
    }
}

#Preview {
    RegisterView()
        .environmentObject(SessionManager())
}
