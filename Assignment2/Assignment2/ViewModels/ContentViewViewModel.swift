//
//  ContentViewViewModel.swift
//  TodoListApp
//
//  Created by Mitchell MacDonald on 2025-10-17.
//

import Foundation
import FirebaseAuth
import Combine
class ContentViewViewModel: ObservableObject {
    @Published var currentUserId: String = ""
    private var handler: AuthStateDidChangeListenerHandle?
    init() {
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUserId = user?.uid ?? ""
            }
        }
    }
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
}
