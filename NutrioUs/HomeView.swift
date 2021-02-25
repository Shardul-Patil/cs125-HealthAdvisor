//
//  HomeView.swift
//  NutrioUs
//
//  Created by Shardul Patil on 2/23/21.
//

import SwiftUI
import Firebase

typealias dataRead = (_ dataRead:Bool) -> Void
var dataGlobal: DocumentSnapshot?

struct HomeView: View {
    @Binding var userId: String?
    let db = Firestore.firestore()
    
    // User Profile
    @State var firstName: String = "temp"
    @State var lastName: String = ""
    @State private var gender: String = ""
    @State var age: String = ""
    @State var height: String = ""
    @State var weight: String = ""
    @State private var activityLevel: String = ""
    @State var dietaryRest: Bool = false
    @State private var dietPlan: String = ""
    @State private var fitnessGoal: String = ""
    
    // Split into List
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
            let _ = readUserData { (dataRead) in
                if dataRead {
                    let _ = populateDataFields(data: dataGlobal)
                }
            }
        }
    }
    
    func populateDataFields(data: DocumentSnapshot?) {
        firstName = data?.get("FirstName") as! String
        lastName = data?.get("LastName") as! String
        gender = data?.get("Gender") as! String
        age = data?.get("Age") as! String
        height = data?.get("Height") as! String
        weight = data?.get("Weight") as! String
        activityLevel = data?.get("ActivityLevel") as! String
        fitnessGoal = data?.get("fitnessGoal") as! String
        let temp = data?.get("dietPlan") as! String
        if (temp == "true"){
            dietaryRest = true
            restrictions = data?.get("restrictions") as! String
        }
        print("Populated Data Fields", firstName, height, age, activityLevel)
    }
    
    func readUserData(completionHandler: @escaping dataRead) {
        var data: DocumentSnapshot? = nil
        print("Reading User Datas")
        db.collection("Users").document(userId!).getDocument { (document, error) in
            if let document = document, document.exists {
                data = document
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                dataGlobal = data
                completionHandler(true)
            } else {
                print("Document does not exist")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(userId: .constant("userId"))
    }
}
