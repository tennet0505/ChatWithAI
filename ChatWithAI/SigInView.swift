//
//  SigInView.swift
//  ChatWithAI
//
//  Created by Oleg Ten on 07/11/2024.
//
import SwiftUI
import FirebaseAuth

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: {
                signInUser()
            }) {
                Text("Sign In")
            }
            .padding()
            Text(errorMessage).foregroundColor(.red)
        }
        .padding()
    }
    
    func signInUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                // Navigate to the chat screen
                print("User signed in: \(result?.user.email ?? "")")
            }
        }
    }
}
