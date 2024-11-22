//
//  FitnessAppApp.swift
//  FitnessApp
//
//  Created by sandra sudheendran on 2024-11-22.
//

import SwiftUI
import Firebase

@main
struct FitnessApp: App {
    init() {
            // Firebase initialization
            FirebaseApp.configure()
        }
        
    var body: some Scene {
        WindowGroup {
            HomePage()
        }
    }
}
