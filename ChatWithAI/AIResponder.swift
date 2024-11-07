//
//  AIResponder.swift
//  ChatWithAI
//
//  Created by Oleg Ten on 07/11/2024.
//

import Foundation
import Combine

class AIResponder {
    private let apiKey = "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" // Replace with your actual API key
    private let baseURL = "https://api.openai.com/v1/chat/completions" // Updated endpoint for chat models
    
    func generateResponse(for prompt: String) -> AnyPublisher<String, Error> {
        guard let url = URL(string: baseURL) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Adjusted parameters for `gpt-3.5-turbo`
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "user", "content": prompt]
            ],
            "max_tokens": 50
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> String in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    let errorResponse = String(data: data, encoding: .utf8) ?? "Unknown error"
                    print("Error: \(errorResponse)")
                    throw URLError(.badServerResponse)
                }
                
                // Parse JSON response for chat models
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let choices = json?["choices"] as? [[String: Any]]
                let message = choices?.first?["message"] as? [String: Any]
                let text = message?["content"] as? String ?? "No response"
                return text
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
