//
//  CreateProfileView.swift
//  NutrioUs
//
//  Created by Shardul Patil on 2/17/21.
//

import SwiftUI

struct CreateProfileView: View {
    // Personal Info
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State private var genderIndex: Int = 0
    var genderOptions = ["Male", "Female", "Other"]
    
    // Current Information
    @State var age: String = ""
    @State var height: String = ""
    @State var weight: String = ""
    @State private var activityIndex: Int = 0
    var activityOptions = ["Sedentary", "Lightly Active", "Moderately Active", "Very Active", "Extra Active"]
    
    // Health Goals
    @State var dietaryRest: Bool = false
    @State private var dietIndex: Int = 0
    var dietOptions = ["None", "Ketogenic", "High Protein", "Carbohydrate Heavy"]
    @State private var fitnessIndex: Int = 0
    var fitnessOptions = ["Maintain Weight", "Moderate Weight Loss", "Advanced Weight Loss", "Moderate Weight Gain", "Advanced Weight Gain"]
    @State var restrictions: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("Personal Information")){
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
                Picker(selection: $genderIndex, label: Text("Gender")){
                    ForEach(0 ..< genderOptions.count){
                        Text(self.genderOptions[$0])
                    }
                }
            }
            Section(header: Text("Current Information")){
                TextField("Age", text: $age)
                TextField("Height (in inches)", text: $height)
                TextField("Weight (in lbs)", text: $weight)
                Picker(selection: $activityIndex, label: Text("Activity Level")){
                    ForEach(0 ..< activityOptions.count){
                        Text(self.activityOptions[$0])
                    }
                }
            }
            Section(header: Text("Health and Diet")){
                Picker(selection: $fitnessIndex, label: Text("Fitness Goal")){
                    ForEach(0 ..< fitnessOptions.count){
                        Text(self.fitnessOptions[$0])
                    }
                }
                Picker(selection: $dietIndex, label: Text("Diet Plan")){
                    ForEach(0 ..< dietOptions.count){
                        Text(self.dietOptions[$0])
                    }
                }
                Toggle(isOn: $dietaryRest){
                    Text("Dietary Restrictions")
                }
                if (dietaryRest == true){
                    TextField("Restrictions (comma separated)", text: $restrictions)
                }
            }
            .navigationBarTitle("Create Your Profile")
        }
    }
}


struct CreateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CreateProfileView()
    }
}
