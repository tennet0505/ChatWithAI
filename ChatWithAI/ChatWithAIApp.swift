//
//  ChatWithAIApp.swift
//  ChatWithAI
//
//  Created by Oleg Ten on 07/11/2024.
//

import SwiftUI
import FirebaseCore

@main
struct ChatWithAIApp: App {
    init() {
           FirebaseApp.configure()  // Initialize Firebase
       }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
