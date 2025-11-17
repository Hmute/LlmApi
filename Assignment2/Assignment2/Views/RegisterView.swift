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
    @EnvironmentObject var session: SessionManager   // 👈 shared auth

    var body: some View {
        VStack {
            HeaderView(
                title: "Assignment 2",
                subtitle: "Join us!",
                angle: 15,
                backColor: .orange
            )
            
            Form {
                if !viewModel.errMsg.isEmpty {
                    Text(viewModel.errMsg)
                        .foregroundColor(.red)
                }
                
                TextField("First Name", text: $viewModel.firstName)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .autocorrectionDisabled()
                
                TextField("Last Name", text: $viewModel.lastName)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .autocorrectionDisabled()
                
                TextField("email", text: $viewModel.email)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                
                SecureField("password", text: $viewModel.password)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                Button("Create Account") {
                    Task {
                        if let auth = await viewModel.register(),
                           viewModel.registrationSuccess {

                            // ✅ Update the session here
                            session.saveSession(
                                token: auth.token,
                                email: auth.email
                            )

                            // now the app “knows” you’re logged in
                            await MainActor.run {
                                dismiss()   // goes back, but ContentView will now show the TabView
                            }
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding()
            }
            .offset(y: -50)
            
            Spacer()
        }
    }
}
