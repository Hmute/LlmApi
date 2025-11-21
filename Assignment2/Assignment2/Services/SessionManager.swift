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
    @Published var token: String = ""
    @Published var hasLoadedSession: Bool = false

    func loadSession() {
        if let token = UserDefaults.standard.string(forKey: "authToken"),
           let email = UserDefaults.standard.string(forKey: "userEmail") {
            self.token = token
            self.currentUserEmail = email
            self.isSignedIn = true
        } else {
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
        token = ""
        currentUserEmail = ""
        isSignedIn = false
        UserDefaults.standard.removeObject(forKey: "authToken")
        UserDefaults.standard.removeObject(forKey: "userEmail")
    }
}

