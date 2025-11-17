//
//  LogoutViewViewModel.swift
//  Assignment 2
//
//  Created by Amal Allaham on 2025-11-15.
//

import Foundation
import Combine


@MainActor
class LogoutViewViewModel: ObservableObject {

    @Published var isLoggedOut = false

    func logout() {
        // Remove the JWT token
        UserDefaults.standard.removeObject(forKey: "authToken")

        isLoggedOut = true
    }
}
