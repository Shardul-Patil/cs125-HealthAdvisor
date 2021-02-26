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
    @State private var firstName: String = "temp"
    @State private var lastName: String = ""
    @State private var gender: String = ""
    @State private var age: String = ""
    @State private var height: String = ""
    @State private var weight: String = ""
    
    // activity
    @State private var activityLevel: String = ""
    @State private var activityDict: Dictionary = ["Sedentary":1.2, "Lightly Active":1.375, "Moderately Active":1.55, "Very Active":1.725, "Extra Active":1.9]
    
    // diet
    @State private var dietaryRest: Bool = false
    @State private var dietPlan: String = ""
    //@State private var dietDict: Dictionary =
    
    // fitness
    @State private var fitnessGoal: String = ""
    @State private var fitnessDict: Dictionary = ["Maintain Weight":0.0, "Moderate Weight Loss":-0.125, "Advanced Weight Loss":-0.25, "Moderate Weight Gain":0.125, "Advanced Weight Gain":0.25]
    
    // Split into List
    @State private var restrictionsTemp: String = ""
    @State private var restrictions: Array = []
    
    // concurrency
    @State private var readCont: Bool = false
    
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
                    print("Finished reading user data")
                    readCont = true
                    let _ = populateDataFields(data: dataGlobal)
                    print("Finished populating user data")
                    readCont = true
                }
            }
            
            // Put the rest of the home body under this if statement
            if (readCont == true){
                Text("Hello, \(firstName)!")
                let tdee = calculateTDEE()
                Text("Your TDEE is: \(tdee) calories")
                
                let macroDict = calculateMacros(tdee: tdee)
                Text("Based on your diet plan \"\(dietPlan)\", your Macronutrient Breakdown is:")
                Text("\(macroDict["carbs"]!) grams of carbohydrates")
                Text("\(macroDict["protein"]!) grams of protein")
                Text("\(macroDict["fats"]!) grams of fat")
            }
            
        }
    }
    
    func populateDataFields(data: DocumentSnapshot?) {
        firstName = data?.get("firstName") as! String
        lastName = data?.get("lastName") as! String
        gender = data?.get("gender") as! String
        age = data?.get("age") as! String
        height = data?.get("height") as! String
        weight = data?.get("weight") as! String
        activityLevel = data?.get("activityLevel") as! String
        fitnessGoal = data?.get("fitnessGoal") as! String
        dietPlan = data?.get("dietPlan") as! String
        let temp = data?.get("dietaryRestBool") as! Bool
        if (temp == true){
            dietaryRest = true
            restrictionsTemp = data?.get("restrictions") as! String
            restrictions = restrictionsTemp.components(separatedBy: ",")
        }
        //print("Populated Data Fields", firstName, height, age, activityLevel)
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
    
    func calculateTDEE() -> Int {
        
        let weightKg = round(Double(weight)!*0.453592)
        let heightCm = round(Double(height)!*2.54)
        // Mifflin-St. Jeor TDEE equation
        var tdee = (10 * weightKg) + (6.25 * heightCm) - (5 * Double(age)!)
        
        if (gender == "male") {
            tdee += 5
        } else {
            tdee -= 161
        }
        
        tdee *= activityDict[activityLevel]!
        tdee += (tdee * fitnessDict[fitnessGoal]!)
        
        return Int(round(tdee))
    }
    
    func calculateMacros(tdee: Int) -> Dictionary<String, Int> {
        var ret: Dictionary<String, Int> = [:]
        if (dietPlan == "Ketogenic"){
            ret["carbs"] = Int(round((Double(tdee)*0.1)/4))
            ret["protein"] = Int(round((Double(tdee)*0.3)/4))
            ret["fats"] = Int(round((Double(tdee)*0.6)/9))
        }
        else if (dietPlan == "High Protein"){
            ret["carbs"] = Int(round((Double(tdee)*0.35)/4))
            ret["protein"] = Int(round((Double(tdee)*0.45)/4))
            ret["fats"] = Int(round((Double(tdee)*0.2)/9))
        }
        else if (dietPlan == "Carbohydrate Heavy") {
            ret["carbs"] = Int(round((Double(tdee)*0.65)/4))
            ret["protein"] = Int(round((Double(tdee)*0.20)/4))
            ret["fats"] = Int(round((Double(tdee)*0.15)/9))
        }
        else {
            ret["carbs"] = Int(round((Double(tdee)*0.5)/4))
            ret["protein"] = Int(round((Double(tdee)*0.3)/4))
            ret["fats"] = Int(round((Double(tdee)*0.2)/9))
        }
        return ret
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(userId: .constant("userId"))
    }
}
