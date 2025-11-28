import Foundation

struct ChatResponse: Decodable {
    let reply: String
}

class ChatService {
    
    private let baseURL = URL(string: "https://assigment2-llmapi-gjdsdme2dvfhg0ff.canadacentral-01.azurewebsites.net/api/Chat")!
    private let session: SessionManager
    
    init(session: SessionManager) {
        self.session = session
    }
    
    private var authToken: String? {
        session.token
    }
    
    func sendPrompt(_ prompt: String) async throws -> String {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = authToken, !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("🔐 Using token:", token.prefix(10), "...")
        } else {
            print("⚠️ No auth token — request will likely return 401")
        }
        
        let body = ["prompt": prompt]
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        print("🌐 Status Code:", http.statusCode)
        
        if http.statusCode != 200 {
            let raw = String(data: data, encoding: .utf8) ?? "<non-UTF8>"
            print("❌ Server Error Response:", raw)
            
            throw NSError(
                domain: "",
                code: http.statusCode,
                userInfo: [NSLocalizedDescriptionKey: "HTTP \(http.statusCode): \(raw)"]
            )
        }
        
        do {
            let decoded = try JSONDecoder().decode(ChatResponse.self, from: data)
            return decoded.reply
        } catch {
            let raw = String(data: data, encoding: .utf8) ?? "<unable to decode>"
            print("❌ JSON DECODE ERROR:", raw)
            throw error
        }
    }
}
