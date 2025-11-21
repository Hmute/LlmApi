//
//  AIViewViewModel.swift
//  Assignment2
//

import SwiftUI
import Combine

@MainActor
class AIViewViewModel: ObservableObject {
    private let session: SessionManager
    // Existing requirement: keep userId
    private let userId: String
    
    // New AI properties
    @Published var prompt: String = ""
    @Published var response: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    private let service = ChatService()
    
    init(userId: String, session: SessionManager) {
        self.userId = userId
        self.session = session

    }
    
    func askAI() {
        Task {
            isLoading = true
            errorMessage = ""
            service.token = session.token
            do {
                let reply = try await service.sendPrompt(prompt)
                response = reply
            } catch {
                errorMessage = "Errodeedewecfqrwr: \(error.localizedDescription)"
            }
            
            isLoading = false
        }
    }
}
