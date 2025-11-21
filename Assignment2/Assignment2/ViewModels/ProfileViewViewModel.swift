//
//  ProfileViewViewModel.swift
//  TodoListApp
//
//  Created by Mitchell MacDonald on 2025-10-17.
//
import Foundation
import Combine
class ProfileViewViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    private let session: SessionManager

    init(session: SessionManager) {
        self.session = session
    }

    
    func fetchUser() {
        guard !session.token.isEmpty else {
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
        request.setValue("Bearer \(session.token)", forHTTPHeaderField: "Authorization")

        // Custom decoder that handles fractional seconds
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            // Try ISO8601 with fractional seconds
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = isoFormatter.date(from: dateStr) {
                return date
            }

            // Fallback: use DateFormatter for precise fractional seconds
            let fallbackFormatter = DateFormatter()
            fallbackFormatter.locale = Locale(identifier: "en_US_POSIX")
            fallbackFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS"
            if let date = fallbackFormatter.date(from: dateStr) {
                return date
            }

            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode date string \(dateStr)"
            )
        }


        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: User.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    self.errorMessage = "Failed to fetch profile: \(error.localizedDescription)"
                    self.user = nil
                }
            } receiveValue: { user in
                self.user = user
                self.errorMessage = ""
            }
            .store(in: &cancellables)
    }



    func logout() {
        session.signOut()
        self.user = nil
    }
}

