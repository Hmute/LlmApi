//
//  RegisterViewViewModel.swift
//  TodoListApp
//
//  Created by Mitchell MacDonald on 2025-10-17.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

@MainActor
class RegisterViewViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var errMsg = ""
    init() {
    }
    func register() {
        print("Register button tapped")

        guard validate() else {
            print("Validation failed:", errMsg)
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errMsg = error.localizedDescription
                }
                print("Firebase Auth Error:", error.localizedDescription)
                return
            }

            print("Firebase Auth success")

            guard let userId = result?.user.uid else {
                print("Could not unwrap userId")
                return
            }

            self?.insertUserRecord(id: userId)
        }
    }

    private func insertUserRecord(id: String) {
        print("Inserting Firestore user record for id:", id)

        let newUser = User(
            id: id,
            firstName: firstName,
            lastName: lastName,
            email: email,
            joined: Date().timeIntervalSince1970
        )
        let db = Firestore.firestore()
        db.collection("users")
            .document(id)
            .setData(newUser.asDictionary())
    }
    
    private func validate() -> Bool {
        errMsg = ""
        guard !firstName.trimmingCharacters(in: .whitespaces).isEmpty,
              !lastName.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            errMsg = "Please fill in First Name, Last Name, Email and Password fields."
            return false
        }
        guard email.contains("@") && email.contains(".") else {
            errMsg = "Please enter a valid email address."
            return false
        }
        guard password.count >= 6 else {
            errMsg = "Password must be at least 6 characters long."
            return false
        }
        return true
    }
}
