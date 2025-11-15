//
//  AIViewViewModel.swift
//  Assignment2
//

import SwiftUI
import Combine
import FirebaseAuth
import FirebaseFirestore

@MainActor
class AIViewViewModel: ObservableObject {
    
    // Existing requirement: keep userId
    private let userId: String
    
    // New AI properties
    @Published var prompt: String = ""
    @Published var response: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    private let service = ChatService()
    
    init(userId: String) {
        self.userId = userId
    }
    
    func askAI() {
        Task {
            isLoading = true
            errorMessage = ""
            
            do {
                let reply = try await service.sendPrompt(prompt)
                response = reply
            } catch {
                errorMessage = "Error: \(error.localizedDescription)"
            }
            
            isLoading = false
        }
    }
}
