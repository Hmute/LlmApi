//
//  User.swift
//  TodoListApp
//
//  Created by Mitchell MacDonald on 2025-10-17.
//

import Foundation
struct User: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let joined: TimeInterval
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
