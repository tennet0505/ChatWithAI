//
//  ChatView.swift
//  ChatWithAI
//
//  Created by Oleg Ten on 07/11/2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var userInput = ""
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(viewModel.messages) { message in
                            HStack {
                                if message.isUser {
                                    Spacer()
                                    Text(message.text)
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                } else {
                                    Text(message.text)
                                        .padding()
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(10)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.messages.count) { _ in
                    // Scroll to the latest message
                    if let lastMessage = viewModel.messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            // User input field and send button
            HStack {
                TextField("Type a message", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button(action: {
                    viewModel.sendMessage(userInput)
                    userInput = ""
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                        .padding()
                }
            }
        }
        .padding(.bottom)
    }
}
