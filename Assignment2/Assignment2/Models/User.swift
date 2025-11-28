//
//  User.swift
//  Assignment2
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let accountCreationDate: Date
    let lastLoginDate: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case email
        case accountCreationDate
        case lastLoginDate
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        email = try container.decode(String.self, forKey: .email)

        // Decode accountCreationDate (non-null)
        let creationStr = try container.decode(String.self, forKey: .accountCreationDate)
        accountCreationDate = User.decodeCustomDate(creationStr)

        // Decode lastLoginDate (nullable)
        if let lastLoginStr = try? container.decode(String.self, forKey: .lastLoginDate) {
            lastLoginDate = User.decodeCustomDate(lastLoginStr)
        } else {
            lastLoginDate = nil
        }
    }

    // Custom date logic for BOTH dates
    private static func decodeCustomDate(_ raw: String) -> Date {
        var dateStr = raw

        // Add timezone if missing
        if !dateStr.hasSuffix("Z") {
            dateStr += "Z"
        }

        // Truncate fractional seconds to 6 digits
        if let dotIndex = dateStr.firstIndex(of: ".") {
            let fractionalStart = dateStr.index(after: dotIndex)
            let fractional = dateStr[fractionalStart...].prefix(while: { $0.isNumber })

            if fractional.count > 6 {
                let truncated = fractional.prefix(6)
                let endIndex = dateStr.index(fractionalStart, offsetBy: fractional.count)
                dateStr.replaceSubrange(fractionalStart..<endIndex, with: truncated)
            }
        }

        // ISO8601 decode
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        return formatter.date(from: dateStr) ?? Date()
    }
}
