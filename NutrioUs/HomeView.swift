//
//  HomeView.swift
//  NutrioUs
//
//  Created by Shardul Patil on 2/23/21.
import SwiftUICharts
import SwiftUI
import Firebase

typealias dataRead = (_ dataRead:Bool) -> Void
typealias fdcIdFound = (_ fdcIdFound:Bool) -> Void
typealias fdcNutritionFound = (_ fdcNutritionFound:Bool) -> Void

var dataGlobal: DocumentSnapshot?
var foodIdGlobal: Int?
var fatGlobal: Double?
var proteinGlobal: Double?
var carbGlobal: Double?
var calorieGlobal: Double?
var currentFoodGlobal: String = ""

var trackCal: Double = 0
var trackCarbs: Double = 0
var trackFat: Double = 0
var trackProtein: Double = 0

// tracking nutrients
//var trackCal: Double = 0
//var trackCarbs: Double = 0
//var trackFat: Double = 0
//var trackProtein: Double = 0

// 0 - No Display, 1 - "Retre
var loadingFoodNutrition: Int = 0

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
    @State private var foodNutritionFound: Bool = false
    
    // User food input
    @State private var fdcUrl: String = "https://api.nal.usda.gov/fdc/v1/foods/search?"
    @State private var fdcNutritionUrl: String = "https://api.nal.usda.gov/fdc/v1/food/"
    @State private var fdcKey: String = "niNJoSpVWtcJ6fJ0nZJ7LVgUfUXJPZWNzkPNzCpG"
    @State var queryFood: String = ""
    
    @State var updater: Bool = false
    @State var selection: Int? = nil
    
    var body: some View {
        VStack (alignment: .center, spacing: 8){
            
            // Only modify non-changing things here such as the title.
            
            Text("NutriosUs")
                .offset(y: -75)
            
            // Debugging only, we will not display userId to the user.
            //Text("Login UID:")
            //Text(userId!)
            if readCont == false {
                let _ = readUserData { (dataRead) in
                    if dataRead {
                        print("Finished reading user data")
                        let _ = populateDataFields(data: dataGlobal)
                        print("Finished populating user data")
                        let tdee = calculateTDEE()
                        let macroDict = calculateMacros(tdee: tdee)
                        updateNutrition(cals: Double(tdee),
                                                carbs: Double(macroDict["carbs"]!),
                                                fat: Double(macroDict["fats"]!),
                                                protein: Double(macroDict["protein"]!))
                        
                        readCont = true
                    }
                }
            }
            // Put the rest of the home body under this if statement
            if (readCont == true){
                
                // TODO: Update UI. In this if statement is where we want to display everything to the user.
                
                Text("Hello, \(firstName)!").font(.largeTitle).fontWeight(.bold).offset(y: -80)
                // TDEE = Total Daily Energy Expenditure. This is essentially how many calories the user should eat in the day.
                
//                let tdee = calculateTDEE()
                // trackCal = Double(tdee)
                Text("Your Calorie Goal for today is: \(Int(trackCal)) calories")
                    .offset(y: -75)
                
                // calculateMacros function takes in tdee and outputs a Dictionary<String, Int>. The key's of the dictionary are: "carbs", "protein", "fats". We want to also display these values to the user.
                
                // All 4 values (calories & 3 macronutrients) will be being updated throughout usage. So any visual indication of that to the user would be nice. Whether its some slider that shows the user how far along they are, pie chart, bar graph, etc. (I'm not creative but I'm sure you will come up with some creative way to display this
                
//                let macroDict = calculateMacros(tdee: tdee)
//
//                let _ = updateNutrition(cals: Double(tdee),
//                                        carbs: Double(macroDict["carbs"]!),
//                                        fat: Double(macroDict["fats"]!),
//                                        protein: Double(macroDict["protein"]!))
                
                BarChartView(data: ChartData(values: [
                            ("carbs", trackCarbs),
                            ("protein", trackProtein),
                            ("fats", trackFat)
                            ]),
                title: "Today's Nutrition Goal",form: ChartForm.medium).offset(y: -75).padding(.bottom, 10).padding(.top, 10)
                
                TextField("Add Food", text: $queryFood)
                    .padding()
                    .background(lightGrey)
                    .cornerRadius(5.0)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .offset(y: -75)
                
                Button(action: {
                    foodNutritionFound = false
                    print("Food Added!")
                    currentFoodGlobal = queryFood
                    let _ = getFoodId(query: currentFoodGlobal) { (fdcIdFound) in
                        if fdcIdFound {
                            print("food id done!")
                            foodIdFound = true
                        }
                    }
                }) {
                    AddFoodButtonContent()
                }.offset(y: -75)
            }
            
            if (readCont == true && foodIdFound == true){
                let _ = getFoodNutrition(foodID: foodIdGlobal!) { (fdcNutritionFound) in
                    if fdcNutritionFound {
                        print("Food nutrition found")
                        foodNutritionFound = true
                        foodIdFound = false
                    }
                }
                
                // set foodIdFound to false
            }
            
            if (foodNutritionFound == true){
                Text("Displaying Food Nutrition for: \(currentFoodGlobal)").offset(y: -75)
                Text("Calories: "+String(round(calorieGlobal!))).offset(y: -75)
                Text("Carbs: "+String(round(carbGlobal!))).offset(y: -75)
                Text("Fats: "+String(round(fatGlobal!))).offset(y: -75)
                Text("Protein: "+String(round(proteinGlobal!))).offset(y: -75)
                
                let _ = subtractNutrition(cals: calorieGlobal!, carbs: carbGlobal!, fat: fatGlobal!, protein: proteinGlobal!)
                let _ = print("cals after subtract: \(trackCal)")
                let _ = foodNutritionFound.toggle()
            }
        }
        
        NavigationLink(destination: RecView(passCal: trackCal, passCarbs: trackCarbs, passFat: trackFat, passProtein: trackProtein, dietPlan: dietPlan), tag: 1, selection: $selection) {
            Button(action: {
                print("Goin to Rec")
                self.selection = 1
                // use Closure technique to wait for Firebase
            }) {
                GetRecsButtonContent()
                }
            }.offset(y: -75)
    }
    
    func updateNutrition(cals:Double, carbs:Double, fat:Double, protein:Double){
        trackCal = cals
        trackCarbs = carbs
        trackFat = fat
        trackProtein = protein
    }
    
    func subtractNutrition(cals:Double, carbs:Double, fat:Double, protein:Double) {
        print ("current cals: \(trackCal), about to subtract: \(cals)")
        trackCal -= cals
        trackCarbs -= carbs
        trackFat -= fat
        trackProtein -= protein
    }
    
    func getFoodId (query: String, completionHandler: @escaping fdcIdFound) {
        print("Getting fdcID for \(query)")
        var fdcId:Int = 0
        var myUrl = URLComponents(string: fdcUrl)
        var items = [URLQueryItem]()
        let encodedquery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let param = [
            "api_key":fdcKey,
            "query":encodedquery]
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
            print("Food ID Found: \(String(describing: foodIdGlobal))")
            completionHandler(true)
        }.resume()
    }
    
    func getFoodNutrition (foodID: Int, completionHandler: @escaping fdcNutritionFound) {
        //print("Getting nutrition for \(foodID)")
        let strUrl = fdcNutritionUrl + String(foodID) + "?api_key=" + fdcKey
        let myUrl = URL(string: strUrl)
        var urlReq = URLRequest(url: myUrl!)
        urlReq.httpMethod = "GET"
        //print("request is \(urlReq)")

        URLSession.shared.dataTask(with: urlReq) { (data, response, error) -> Void in
            let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
            let topEntry = json!["labelNutrients"] as! NSDictionary?
            if (topEntry != nil){
                //print("topEntry Dict: \(String(describing: topEntry))")
                let fDict = topEntry!["fat"] as! NSDictionary
                //print("fDict: \(fDict)")
                let pDict = topEntry!["protein"] as! NSDictionary
                let carbDict = topEntry!["carbohydrates"] as! NSDictionary
                let calDict = topEntry!["calories"] as! NSDictionary
                fatGlobal = fDict["value"] as? Double
                proteinGlobal = pDict["value"] as? Double
                carbGlobal = carbDict["value"] as? Double
                calorieGlobal = calDict["value"] as? Double
                completionHandler(true)
            } else {
                let topEntry = json!["foodNutrients"] as! NSArray
                for nutrient in topEntry {
                    let nutri = nutrient as! NSDictionary
                    let ndata = nutri["nutrient"] as! NSDictionary
                    if (ndata["id"] as! Int == 1003) {
                        proteinGlobal = nutri["amount"] as? Double
                    }
                    if (ndata["id"] as! Int == 1004) {
                        fatGlobal = nutri["amount"] as? Double
                    }
                    if (ndata["id"] as! Int == 1008) {
                        calorieGlobal = nutri["amount"] as? Double
                    }
                    if (ndata["id"] as! Int == 1005) {
                        carbGlobal = nutri["amount"] as? Double
                    }
                }
                
                completionHandler(true)
            }
        }.resume()
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
        trackCal = Double(Int(round(tdee)))
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
struct GetRecsButtonContent : View {
    var body: some View {
        HStack {
            Image(systemName: "plus.message.fill")
                .font(.title)
            Text("Get Recs")
                .fontWeight(.semibold)
                .font(.title3)
        }
        .padding()
        .foregroundColor(.white)
        .background(Color.blue)
        .cornerRadius(40)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(userId: .constant("userId"))
    }
}
