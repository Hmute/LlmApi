//
//  RegisterViewViewModel.swift
//  Assignment 2
//
//  Created by Amal Allaham on 2025-11-15.
//

import Foundation
import Combine

@MainActor
class RegisterViewViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var errMsg = ""
    @Published var isLoading = false
    @Published var registrationSuccess = false
    @Published var isLoggedIn = false

    private let baseURL = "http://localhost:5284"

    func register() async -> AuthResponse? {
        errMsg = ""

        guard validate() else { return nil }

        isLoading = true

        let body = RegisterRequestBody(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password
        )

        guard let url = URL(string: "\(baseURL)/api/Auth/register") else {
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

            if httpResponse.statusCode == 409 {
                errMsg = "A user with this email already exists."
                isLoading = false
                return nil
            }

            if !(200...299).contains(httpResponse.statusCode) {
                errMsg = "Registration failed. Try again."
                isLoading = false
                return nil
            }

            let auth = try JSONDecoder().decode(AuthResponse.self, from: data)


            registrationSuccess = true
            isLoggedIn = true
            isLoading = false

            return auth

        } catch {
            errMsg = error.localizedDescription
            isLoading = false
            return nil
        }
    }

    private func validate() -> Bool {
        if firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty {
            errMsg = "All fields are required."
            return false
        }

        if !email.contains("@") {
            errMsg = "Invalid email format."
            return false
        }

        if password.count < 6 {
            errMsg = "Password must be at least 6 characters."
            return false
        }

        return true
    }
}
