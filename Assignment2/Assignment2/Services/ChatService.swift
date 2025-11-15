import Foundation

struct ChatResponse: Decodable {
    let reply: String
}

class ChatService {
    
    private let baseURL = URL(string: "https://assigment2-llmapi-gjdsdme2dvfhg0ff.canadacentral-01.azurewebsites.net/api/Chat")!
    
    func sendPrompt(_ prompt: String) async throws -> String {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["prompt": prompt]
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)

        // Optional: debug HTTP errors
        if let http = response as? HTTPURLResponse {
            print("Status:", http.statusCode)
        }

        let decoded = try JSONDecoder().decode(ChatResponse.self, from: data)
        return decoded.reply
    }
}
