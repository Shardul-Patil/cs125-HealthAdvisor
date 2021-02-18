//
//  NutrioUsApp.swift
//  NutrioUs
//
//  Created by Shardul Patil on 2/9/21.
//

import SwiftUI
import Firebase

@main
struct NutrioUsApp: App {
    
    init(){
        print("Configuring Firebase")
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            WelcomeView()
        }
    }
}
