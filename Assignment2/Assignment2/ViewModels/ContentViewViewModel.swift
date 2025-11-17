//
//  ContentViewViewModel.swift
//  Assignment 2
//
//  Created by Amal Allaham on 2025-11-16.
//

import Foundation
import Combine

class ContentViewViewModel: ObservableObject {
    @Published var currentUserEmail: String = ""
    @Published var isSignedIn: Bool = false

    init() {
        loadSession()
    }
    
    func loadSession() {
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let email = UserDefaults.standard.string(forKey: "userEmail") ?? ""
        
        isSignedIn = !token.isEmpty
        currentUserEmail = email
    }
    
    func signOut() {
        UserDefaults.standard.removeObject(forKey: "authToken")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        
        isSignedIn = false
        currentUserEmail = ""
    }
}
