//
//  Auth.swift
//  Assignment 2
//
//  Created by Amal Allaham on 2025-11-15.
//

import Foundation

struct LoginRequestBody: Codable {
    let email: String
    let password: String
}


struct RegisterRequestBody: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
}

struct AuthResponse: Codable {
    let token: String
    let firstName: String
    let lastName: String
    let email: String
    let accountCreationDate: String
    let lastLoginDate: String?
}
