import SwiftUI
import Combine

@MainActor
class AIViewViewModel: ObservableObject {
    
    private(set) var session: SessionManager?
    private let userId: String
    
    @Published var prompt: String = ""
    @Published var response: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    private var service: ChatService?

    init(userId: String, session: SessionManager?) {
        self.userId = userId
        self.session = session
        
        if let session = session {
            self.service = ChatService(session: session)
        }
    }
    
    func attachSession(_ session: SessionManager) {
        self.session = session
        self.service = ChatService(session: session)
    }
    
    func askAI() {
        guard let service = service else {
            errorMessage = "Session missing — please log in again."
            return
        }
        
        Task {
            isLoading = true
            errorMessage = ""
            
            do {
                let reply = try await service.sendPrompt(prompt)
                response = reply
            } catch {
                errorMessage = "⚠️ Error: \(error.localizedDescription)"
            }
            
            isLoading = false
        }
    }
}
