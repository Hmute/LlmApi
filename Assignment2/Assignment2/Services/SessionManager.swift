//
//  SessionManager.swift
//  Assignment2
//
//  Created by Amal Allaham on 2025-11-16.
//


import Foundation
import Combine
import SwiftUI

final class SessionManager: ObservableObject {
    @Published var isSignedIn: Bool = false
    @Published var currentUserEmail: String = ""
    @Published var token: String? = nil
    @Published var hasLoadedSession: Bool = false

    func loadSession() {
        if let storedToken = UserDefaults.standard.string(forKey: "authToken"),
           let storedEmail = UserDefaults.standard.string(forKey: "userEmail") {
            self.token = storedToken
            self.currentUserEmail = storedEmail
            self.isSignedIn = true
        } else {
            self.token = nil
            self.currentUserEmail = ""
            self.isSignedIn = false
        }
        self.hasLoadedSession = true
    }

    func saveSession(token: String, email: String) {
        self.token = token
        self.currentUserEmail = email
        self.isSignedIn = true
        UserDefaults.standard.set(token, forKey: "authToken")
        UserDefaults.standard.set(email, forKey: "userEmail")
    }

    func signOut() {
        token = nil
        currentUserEmail = ""
        isSignedIn = false
        UserDefaults.standard.removeObject(forKey: "authToken")
        UserDefaults.standard.removeObject(forKey: "userEmail")
    }
}

