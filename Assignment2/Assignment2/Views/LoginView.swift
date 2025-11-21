//
//  LoginView.swift
//  TodoListApp
//
//  Created by Amal Allaham on 2025-10-17.
//
import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewViewModel()
    @EnvironmentObject var session: SessionManager

    var body: some View {
        NavigationStack {  // ✅ Add NavigationStack here
            ZStack {
                // Background gradient
                LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    // Cool header
                    HeaderView(title: "AI App", subtitle: "Login")
                        .frame(height: 250)
                        .padding(.bottom, 20)

                    // Form card
                    VStack(spacing: 16) {
                        if !viewModel.errMsg.isEmpty {
                            Text(viewModel.errMsg)
                                .foregroundColor(.red)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                        }

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
                                if let auth = await viewModel.login() {
                                    session.saveSession(token: auth.token, email: auth.email)
                                }
                            }
                        }) {
                            Text("Login")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(LinearGradient(colors: [.pink, .purple], startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(15)
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                        }

                    }
                    .padding(24)
                    .background(.ultraThinMaterial)
                    .cornerRadius(25)
                    .padding(.horizontal)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)

                    // Bottom navigation
                    VStack(spacing: 8) {
                        Text("New User?")
                            .foregroundColor(.white.opacity(0.8))

                        NavigationLink(destination: RegisterView()) {
                            Text("Create Account")
                                .foregroundColor(.white)
                                .bold()
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(Color.purple.opacity(0.7))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.top, 20)

                    Spacer()
                }
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(SessionManager())
}
