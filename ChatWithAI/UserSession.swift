//
//  UserSession.swift
//  ChatWithAI
//
//  Created by Oleg Ten on 07/11/2024.
//

import SwiftUI
import Combine
import FirebaseAuth

class UserSession: ObservableObject {
    @Published var isAuthenticated = false
    init() {
        if Auth.auth().currentUser != nil {
            self.isAuthenticated = true
        }
    }
}
