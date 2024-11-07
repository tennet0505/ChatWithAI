//
//  ContentView.swift
//  ChatWithAI
//
//  Created by Oleg Ten on 07/11/2024.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject private var session = UserSession()

    var body: some View {
        VStack {
//            if session.isAuthenticated {
                ChatView()
//            } else {
//                SignInView() // Show SignUpView or SignInView based on needs
//            }
        }
//        .onChange(of: Auth.auth().currentUser) { newUser in
//            session.isAuthenticated = newUser != nil
//        }
    }
}


#Preview {
    ContentView()
}
