//
//  NutrioUsApp.swift
//  NutrioUs
//
//  Created by Shardul Patil on 2/9/21.
//

import SwiftUI
import Firebase
import HealthKit

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
