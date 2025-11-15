//
//  LoginView.swift
//  TodoListApp
//
//  Created by Mitchell MacDonald on 2025-10-17.
//
import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewViewModel()
    @Environment(\.verticalSizeClass) var verticalSizeClass

    var body: some View {
        NavigationView {
            Group {
                if verticalSizeClass == .regular {
                    portraitView
                } else {
                    landscapeView
                }
            }
        }
    }



    @ViewBuilder
    var portraitView: some View {
        VStack {
            HeaderView(title: "Todo List", subtitle: "login", angle: 15, backColor: .blue)

            Form {
                if !viewModel.errMsg.isEmpty {
                    Text(viewModel.errMsg)
                        .foregroundColor(.red)
                }

                TextField("email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .autocorrectionDisabled()

                SecureField("password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("login") {
                    viewModel.login()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }

            VStack {
                Text("user")
                NavigationLink("account") {
                    RegisterView()
                }
            }
            .padding(.bottom, 50)
            Spacer()
        }
    }

    // MARK: - Landscape layout
    @ViewBuilder
    var landscapeView: some View {
        HStack(spacing: 16) {
            HeaderView(title: "Todo List", subtitle: "login", angle: 0, backColor: .blue)
                .frame(width: 250, height: 300)
                .cornerRadius(20)
                

            VStack {
                Form {
                    if !viewModel.errMsg.isEmpty {
                        Text(viewModel.errMsg)
                            .foregroundColor(.red)
                    }

                    TextField("email", text: $viewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .autocorrectionDisabled()

                    SecureField("password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button("login") {
                        viewModel.login()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }

                VStack {
                    Text("user")
                    NavigationLink("account") {
                        RegisterView()
                    }
                }
                .padding(.bottom, 30)
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
    }

}


#Preview {
    LoginView()
}
