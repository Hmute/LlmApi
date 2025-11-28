//
//  ProfileViewViewModel.swift
//  Assignment2
//

import SwiftUI
import Combine
import Foundation

@MainActor
class ProfileViewViewModel: ObservableObject {
    
    @Published var user: User?
    @Published var errorMessage: String = ""
    
    private var session: SessionManager? = nil

    init() { }

    // Attach the REAL environment session from ProfileView
    func attachSession(_ session: SessionManager) {
        self.session = session
    }

    // Logout
    func logout() {
        session?.signOut()
    }

    // MARK: - Fetch User (/api/Auth/me)
    func fetchUser() {
        guard let session = session else {
            errorMessage = "Session missing"
            return
        }

        guard let token = session.token, !token.isEmpty else {
            self.errorMessage = "User not authenticated"
            self.user = nil
            return
        }

        let urlString = "https://assigment2-llmapi-gjdsdme2dvfhg0ff.canadacentral-01.azurewebsites.net/api/Auth/me"
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        // MARK: - JSON Decoder (Handles Microsecond+ Dates)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            var dateStr = try container.decode(String.self)

            // Handle null dates explicitly
            if dateStr == "null" {
                throw DecodingError.valueNotFound(Date.self,
                    .init(codingPath: decoder.codingPath,
                          debugDescription: "Null date"))
            }

            // Append Z if timezone missing
            if !dateStr.hasSuffix("Z") {
                dateStr.append("Z")
            }

            // Handle fractional seconds > 6 digits
            if let dotIndex = dateStr.firstIndex(of: ".") {
                let start = dateStr.index(after: dotIndex)
                let fractional = dateStr[start...].prefix { $0.isWholeNumber }

                if fractional.count > 6 {
                    // Truncate to 6 fractional digits (max Swift supports)
                    let truncated = fractional.prefix(6)
                    let end = dateStr.index(start, offsetBy: fractional.count)
                    dateStr.replaceSubrange(start..<end, with: truncated)
                }
            }

            // Decode using ISO8601 with fractional seconds
            let iso = ISO8601DateFormatter()
            iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

            if let date = iso.date(from: dateStr) {
                return date
            }

            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid date format: \(dateStr)"
            )
        }

        // MARK: - Network Request
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(for: request)

                guard let http = response as? HTTPURLResponse else {
                    self.errorMessage = "Invalid server response"
                    return
                }

                print("🌐 /Auth/me Status:", http.statusCode)
                print("🔍 RAW RESPONSE:", String(data: data, encoding: .utf8) ?? "<non-utf8>")

                if http.statusCode != 200 {
                    let raw = String(data: data, encoding: .utf8) ?? "<no body>"
                    self.errorMessage = "HTTP \(http.statusCode): \(raw)"
                    return
                }

                // Decode the User model
                let fetchedUser = try decoder.decode(User.self, from: data)
                self.user = fetchedUser
                self.errorMessage = ""

            } catch {
                self.errorMessage = "The data couldn’t be read because it isn’t in the correct format."
                print("❌ DECODE ERROR:", error)
            }
        }
    }
}
