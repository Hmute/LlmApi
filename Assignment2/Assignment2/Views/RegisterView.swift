//
//  RegisterView.swift
//  TodoListApp
//
//  Created by Mitchell MacDonald on 2025-10-17.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewViewModel()
    
    var body: some View {
        VStack {
            HeaderView(title: "Assignment 2", subtitle: "Join us!", angle: 15, backColor: .orange)
            
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
                    viewModel.register()
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

#Preview {
    RegisterView()
}
