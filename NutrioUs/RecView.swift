//
//  RecView.swift
//  NutrioUs
//
//  Created by Shardul Patil on 3/11/21.
//

import SwiftUI

struct RecView: View {
    var passCal: Double
    var passCarbs: Double
    var passFat: Double
    var passProtein: Double
    
    var body: some View {
        Text("Looks like you still need:")
        Text("Int\(passCal)) calories")
        Text("Int\(passCarbs)) grams of carbs")
        Text("Int\(passFat)) grams of fat")
        Text("Int\(passProtein)) grams of protein")
    }
}

struct RecView_Previews: PreviewProvider {
    static var previews: some View {
        RecView(passCal: 5.0, passCarbs: 5.0, passFat: 5.0, passProtein: 5.0)
    }
}
