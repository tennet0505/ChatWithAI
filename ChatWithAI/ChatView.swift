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
    @State private var message = ""
    @State private var messages: [Message] = []
    let userId = Auth.auth().currentUser?.uid ?? "guest"
    private let db = Firestore.firestore()

    var body: some View {
        VStack {
            ScrollView {
                ForEach(messages) { message in
                    VStack(alignment: .leading) {
                        Text(message.text)
                            .padding()
                            .background(Color.gray.opacity(0.2), cornerRadius: 10)
                    }
                    .padding(.bottom, 10)
                }
            }
            HStack {
                TextField("Enter message", text: $message)
                    .padding(10)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Send") {
                    sendMessage()
                }
                .padding()
            }
            .padding()
        }
        .onAppear(perform: loadMessages)
    }

    func sendMessage() {
        let newMessage = Message(id: UUID().uuidString, text: message)
        db.collection("users").document(userId).collection("conversations").addDocument(data: [
            "text": newMessage.text,
            "timestamp": Timestamp()
        ]) { error in
            if let error = error {
                print("Error sending message: \(error)")
            } else {
                message = ""
                loadMessages()
            }
        }
    }
    
    func loadMessages() {
        db.collection("users").document(userId).collection("conversations")
            .order(by: "timestamp", ascending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error loading messages: \(error)")
                } else {
                    messages = snapshot?.documents.compactMap { document in
                        let data = document.data()
                        guard let text = data["text"] as? String else { return nil }
                        return Message(id: document.documentID, text: text)
                    } ?? []
                }
            }
    }
    
    func savePreferences(userId: String, darkModeEnabled: Bool) {
        let preferencesRef = db.collection("users").document(userId).collection("preferences")
        preferencesRef.document("darkMode").setData([
            "enabled": darkModeEnabled
        ]) { error in
            if let error = error {
                print("Error saving preference: \(error)")
            } else {
                print("Preference saved")
            }
        }
    }
}

struct Message: Identifiable {
    var id: String
    var text: String
}
