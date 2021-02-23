//
//  HomeView.swift
//  NutrioUs
//
//  Created by Shardul Patil on 2/23/21.
//

import SwiftUI
import Firebase

struct HomeView: View {
    // Modify to Binding
    @Binding var userId: String?
    @State var tempUserId: String = "VddZVKo2JjcQcy80bAlqjzLMKtz1"
    let db = Firestore.firestore()
    
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var gender: String = ""
    
    // Current Information
    @State var age: String = ""
    @State var height: String = ""
    @State var weight: String = ""
    @State var activityLevel: String = ""
    
    // Health Goals
    @State var dietaryRest: Bool = false
    @State var dietType: String = ""
    @State var fitnessGoal: String = ""
    
    // split into List
    @State var restrictions: String = ""
    var body: some View {
        VStack (alignment: .center, spacing: 10){
            
            Text("TITLE")
                // Change font size
                .font(.title)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
            Text("Login UID:")
            Text(userId!)
        }
    }
    
    func readUserData(){
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(userId: .constant("userId"))
    }
}
