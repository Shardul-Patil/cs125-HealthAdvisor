//
//  SignUpView.swift
//  CS125_NutriUs
//
//  Created by Max Doan on 2/9/21.
//

import SwiftUI
import Firebase

//private let database = Database.database().reference()

let color = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0)

struct SignUpView: View {
    
    @State var title: String =
    """
    NutrioUs
    Our Health in Our Hands
    """
    @State var selection: Int? = nil
    
    @State var email: String = ""
    @State var username: String = ""
    @State var password: String = ""
    @State var passwordConf: String = ""
    @State var userId: String? = ""
    
    var body: some View
    {
        NavigationView(){
            VStack (alignment: .center, spacing: 10){
                
                Text(title)
                    // Change font size
                    .font(.title)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                TextField("Email", text: $email)
                    .padding()
                    .background(lightGrey)
                    .cornerRadius(5.0)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                /* TextField("Username", text: $username)
                    .padding()
                    .background(lightGrey)
                    .cornerRadius(5.0)
                */
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(lightGrey)
                    .cornerRadius(5.0)
                /* SecureField("Password Confirmation ", text: $passwordConf)
                    .padding()
                    .background(lightGrey)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                */
                
                NavigationLink(destination: CreateProfileView(userId: self.$userId, email: self.$email), tag: 1, selection: $selection) {
                    Button(action: {
                        userId = signUp(email: email, password: password)
                        self.selection = 1
                    }) {
                        SignupButtonContent()
                        }
                    }
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

func signUp(email: String, password: String) -> String?{
    Auth.auth().createUser(withEmail: email, password: password)
    let user = Auth.auth().currentUser;
    if (user != nil) {
        //user is signed in
        let uid = user?.uid
        print("SUCESS, uid is ")
        print(uid!)
        return uid
    } else {
        return nil
    }
    //Auth.auth().createUser(withEmail: email, password: password) {authResult, error in }
    
}



/* func addMeal(name: String, cal: Int, protein: Int){
    
    let object: [String: String] = [
        "name": name,
        "Youtube": "yes"]
    
    //database.child("something").setValue(object)
    //set value to null to delete something key
}
*/

/* func listen() {
    _ = Auth.auth().addStateDidChangeListener { (auth, user) in
        if let user = user {
            self.session
        }
    }
}
*/
