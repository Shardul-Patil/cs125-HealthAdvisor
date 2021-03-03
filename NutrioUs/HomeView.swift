//
//  HomeView.swift
//  NutrioUs
//
//  Created by Shardul Patil on 2/23/21.
//

import SwiftUI
import Firebase

typealias dataRead = (_ dataRead:Bool) -> Void
typealias fdcIdFound = (_ fdcIdFound:Bool) -> Void
var dataGlobal: DocumentSnapshot?
var foodIdGlobal: Int?

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
    @State private var foodIdFound: Bool = false
    
    // User food input
    @State private var fdcUrl: String = "https://api.nal.usda.gov/fdc/v1/foods/search?"
    @State private var fdcKey: String = "niNJoSpVWtcJ6fJ0nZJ7LVgUfUXJPZWNzkPNzCpG"
    @State var queryFood: String = ""
    var body: some View {
        VStack (alignment: .center, spacing: 10){
            
            // Only modify non-changing things here such as the title.
            
            Text("TITLE")
                // Change font size
                .font(.title)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
            
            // Debugging only, we will not display userId to the user.
            Text("Login UID:")
            Text(userId!)
            if readCont == false {
                let _ = readUserData { (dataRead) in
                    if dataRead {
                        print("Finished reading user data")
                        readCont = true
                        let _ = populateDataFields(data: dataGlobal)
                        print("Finished populating user data")
                        readCont = true
                    }
                }
            }
            
            // Put the rest of the home body under this if statement
            if (readCont == true){
                
                // TODO: Update UI. In this if statement is where we want to display everything to the user.
                
                Text("Hello, \(firstName)!")
                // TDEE = Total Daily Energy Expenditure. This is essentially how many calories the user should eat in the day.
                
                let tdee = calculateTDEE()
                Text("Your TDEE is: \(tdee) calories")
                
                // calculateMacros function takes in tdee and outputs a Dictionary<String, Int>. The key's of the dictionary are: "carbs", "protein", "fats". We want to also display these values to the user.
                
                // All 4 values (calories & 3 macronutrients) will be being updated throughout usage. So any visual indication of that to the user would be nice. Whether its some slider that shows the user how far along they are, pie chart, bar graph, etc. (I'm not creative but I'm sure you will come up with some creative way to display this
                
                let macroDict = calculateMacros(tdee: tdee)
                
                Text("Based on your diet plan \"\(dietPlan)\", your Macronutrient Breakdown is:")
                Text("\(macroDict["carbs"]!) grams of carbohydrates")
                Text("\(macroDict["protein"]!) grams of protein")
                Text("\(macroDict["fats"]!) grams of fat")
                TextField("Add Food", text: $queryFood)
                    .padding()
                    .background(lightGrey)
                    .cornerRadius(5.0)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                Button(action: {
                    print("Food Added!")
                    let _ = getFoodId(query: queryFood) { (fdcIdFound) in
                        if fdcIdFound {
                            print("food id done!")
                            foodIdFound = true
                        }
                    }
                }) {
                    AddFoodButtonContent()
                }
            }
            
            if (readCont == true && foodIdFound == true){
                Text("Displaying Food ID for: \(queryFood)")
                Text(String(foodIdGlobal!))
                // set foodIdFound to false
            }
        }
    }
    
    
    
    func getFoodId (query: String, completionHandler: @escaping fdcIdFound) {
        var fdcId:Int = 0
        var myUrl = URLComponents(string: fdcUrl)
        var items = [URLQueryItem]()
        let param = [
            "api_key":fdcKey,
            "query":query]
        for (key,value) in param {
            items.append(URLQueryItem(name: key, value: value))
        }
        myUrl?.queryItems = items
        var urlReq = URLRequest(url: (myUrl?.url)!)
        urlReq.httpMethod = "GET"
        URLSession.shared.dataTask(with: urlReq) { (data, response, error) -> Void in
            // Index into json response
            let json =  try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
            let topEntry = json!["foods"] as! NSArray
            let secondEntry = topEntry[0] as! NSDictionary
            fdcId = secondEntry["fdcId"] as! Int
            foodIdGlobal = fdcId
            completionHandler(true)
        }.resume()
    }
    
    func getFoodData (foodID: Int) {
        // will follow foodId format to get nutrional info for any given food id
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

struct AddFoodButtonContent : View {
    var body: some View {
        HStack {
            Image(systemName: "plus.circle")
                .font(.title)
            Text("Add Food")
                .fontWeight(.semibold)
                .font(.title3)
        }
        .padding()
        .foregroundColor(.white)
        .background(Color.green)
        .cornerRadius(40)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(userId: .constant("userId"))
    }
}
