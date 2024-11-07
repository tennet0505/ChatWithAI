//
//  ChatViewModel.swift
//  ChatWithAI
//
//  Created by Oleg Ten on 07/11/2024.
//

import SwiftUI
import Combine

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    private var cancellables = Set<AnyCancellable>()
    private let aiResponder = AIResponder()
    
    func sendMessage(_ text: String) {
        // Display user message
        let userMessage = ChatMessage(text: text, isUser: true)
        messages.append(userMessage)
        
        // Send to AI and wait for response
        aiResponder.generateResponse(for: text)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Failed to get response: \(error)")
                }
            }, receiveValue: { [weak self] responseText in
                let aiMessage = ChatMessage(text: responseText, isUser: false)
                self?.messages.append(aiMessage)
            })
            .store(in: &cancellables)
    }
}
