//
//  LoginViewViewModel.swift
//  Assignment 2
//
//  Created by Amal Allaham on 2025-11-15.
//

import Foundation
import Combine
@MainActor
class LoginViewViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errMsg = ""
    @Published var isLoading = false
    @Published var isLoggedIn = false   // can be kept if you want local UI state

    private let baseURL = "https://assigment2-llmapi-gjdsdme2dvfhg0ff.canadacentral-01.azurewebsites.net"

    func login() async -> AuthResponse? {
        errMsg = ""
        guard validate() else { return nil }

        isLoading = true

        let body = LoginRequestBody(email: email, password: password)

        guard let url = URL(string: "\(baseURL)/api/Auth/login") else {
            errMsg = "Invalid server URL."
            isLoading = false
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                errMsg = "Invalid server response."
                isLoading = false
                return nil
            }

            if httpResponse.statusCode == 401 {
                errMsg = "Invalid email or password."
                isLoading = false
                return nil
            }

            if !(200...299).contains(httpResponse.statusCode) {
                errMsg = "Server error. Try again."
                isLoading = false
                return nil
            }

            let auth = try JSONDecoder().decode(AuthResponse.self, from: data)


            isLoggedIn = true
            isLoading = false

            return auth   
        } catch {
            errMsg = "Network error. Please try again."
            isLoading = false
            return nil
        }
    }

    private func validate() -> Bool {
        errMsg = ""

        guard !email.isEmpty, !password.isEmpty else {
            errMsg = "Please fill in email and password fields."
            return false
        }

        guard email.contains("@"), email.contains(".") else {
            errMsg = "Please enter a valid email address."
            return false
        }

        return true
    }
}
