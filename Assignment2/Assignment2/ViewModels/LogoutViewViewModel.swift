//
//  LogoutViewViewModel.swift
//  TodoListApp
//
//  Created by Mitchell MacDonald on 2025-10-31.
//

import Foundation
import Foundation
import FirebaseAuth
import Combine
class LogoutViewViewModel : ObservableObject {
    init() {}
    func logout() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
