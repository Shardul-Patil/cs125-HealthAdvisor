//
//  RecView.swift
//  NutrioUs
//
//  Created by Shardul Patil on 3/11/21.
//

import SwiftUI
import Firebase
import SwiftUICharts

typealias queryRecs = (_ queryRecs:Bool) -> Void

struct RecView: View {
    var passCal: Double
    var passCarbs: Double
    var passFat: Double
    var passProtein: Double
    var dietPlan: String
    
    @State private var queryDone:Bool = false
    
    let dietConv = ["None": "calories", "Ketogenic": "fats", "High Protein": "protein", "Carbohydrate Heavy": "carbs"]
    
    @State var recList:[String] = []
    
    let db = Firestore.firestore()
    
    var body: some View {
        Text("Diet Plan: \(dietPlan)").offset(y: -20)
        Text("You still need...").font(.largeTitle).offset(y: -10)
        Text("\(Int(passCal)) calories")
        
        BarChartView(data: ChartData(values: [
                    ("carbs", Int(trackCarbs)),
                    ("protein", Int(trackProtein)),
                    ("fats", Int(trackFat))
                    ]),
        title: "Remaining Nutrients",form: ChartForm.medium).padding(.bottom, 10).padding(.top, 10)
        
//        Text("\(Int(passCarbs)) grams of carbs")
//        Text("\(Int(passFat)) grams of fat")
//        Text("\(Int(passProtein)) grams of protein")
        if (queryDone == false){
            let _ = queryFirebase { (queryRecs) in
                if queryRecs {
                    print("Finished querying firebase")
                    queryDone = true
                }
            }
        }
        if (queryDone == true){
            List {
                ForEach(recList, id:\.self) { item in
                    Text(item)
                }
            }
        }
    }
    
    func queryFirebase(completionHandler: @escaping queryRecs){
        let foodRef = db.collection("Food")
        
        let calv = Int(passCal)/2
        let caldiff = Double(calv)*0.1
        let calmin = Double(calv) - caldiff
        let calmax = Double(calv) + caldiff
        
        foodRef
            .whereField("calories", isLessThan: calmax)
            .whereField("calories", isGreaterThan: calmin)
            .limit(to: 5)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let docId = document.documentID
                        let rest = document.data()["restaurant"]!
                        let c = round(document.data()["calories"]! as! Double)
                        let car = round(document.data()["carbs"]! as! Double)
                        let f = round(document.data()["fats"]! as! Double)
                        let p = round(document.data()["protein"]! as! Double)
                        recList.append(
                            "\(docId)\nfrom \(rest)\n\(c) cal, \(car)g carbs, \(p)g protein, \(f)g fat")
                    }
                    completionHandler(true)
                }
            }
    }
}
//        let carbv = Int(passCarbs)/2
//        let carbdiff = Double(carbv)*0.15
//        let carbmin = Double(carbv) - carbdiff
//        let carbmax = Double(carbv) + carbdiff
//
//        let fatv = Int(passFat)/2
//        let fatdiff = Double(fatv)*0.15
//        let fatmin = Double(fatv) - fatdiff
//        let fatmax = Double(fatv) + fatdiff
//
//        let protv = Int(passProtein)/2
//        let protdiff = Double(protv)*0.15
//        let protmin = Double(protv) - protdiff
//        let protmax = Double(protv) + protdiff
        
//            .whereField("carbs", isLessThan: carbmax)
//            .whereField("carbs", isGreaterThan: carbmin)
//            .whereField("fats", isLessThan: fatmax)
//            .whereField("fats", isGreaterThan: fatmin)
//            .whereField("protein", isLessThan: protmax)
//            .whereField("protein", isGreaterThan: protmin)

struct RecView_Previews: PreviewProvider {
    static var previews: some View {
        RecView(passCal: 5.0, passCarbs: 5.0, passFat: 5.0, passProtein: 5.0, dietPlan: "")
    }
}
