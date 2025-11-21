//
//  User.swift
//  TodoListApp
//
//  Created by Mitchell MacDonald on 2025-10-17.
//

import Foundation
struct User: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let accountCreationDate: Date
    let lastLoginDate: Date

    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case email
        case accountCreationDate
        case lastLoginDate
    }
}

extension User {
    func asDictionary() -> [String: Any] {
        do {
            let data = try JSONEncoder().encode(self)
            let json = try JSONSerialization.jsonObject(with: data)
            return json as? [String: Any] ?? [:]
        } catch {
            print("Error converting User to dictionary:", error)
            return [:]
        }
    }
}
