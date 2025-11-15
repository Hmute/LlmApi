//
//  ProfileViewViewModel.swift
//  TodoListApp
//
//  Created by Mitchell MacDonald on 2025-10-17.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore
class ProfileViewViewModel: ObservableObject {
    @Published var user: User? = nil
    init() {
        
    }
    func logout() {
        do {
        try Auth.auth().signOut()
        } catch {
        print (error)
        }
    }
    func fetchUser() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument {[weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            DispatchQueue.main.async {
                self?.user = User(
                    id: data["id"] as? String ?? "",
                    firstName: data["firstName"] as? String ?? "",
                    lastName: data["lastName"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    joined: data["joined"] as? TimeInterval ?? 0
                )
            }
        }
    }
}
