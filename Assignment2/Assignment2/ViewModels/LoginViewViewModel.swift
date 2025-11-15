//
//  LoginViewViewModel.swift
//  TodoListApp
//
//  Created by Mitchell MacDonald on 2025-10-17.
//

import Foundation
import Combine
import FirebaseAuth
class LoginViewViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errMsg = ""
    init() {
        // Default initializer; no additional setup needed.
    }
    func login() {
        guard validate() else {
        return
        }
        Auth.auth().signIn(withEmail: email, password: password)
    }
    
    private func validate() -> Bool {
        errMsg = ""
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            errMsg = "Please fill in email and password fields."
            return false
        }
        // email@foo.com
        guard email.contains("@") && email.contains(".") else {
            errMsg = "Please enter a valid email address."
            return false
        }
        return true
    }
}
