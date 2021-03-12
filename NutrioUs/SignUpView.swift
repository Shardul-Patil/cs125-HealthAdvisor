//
//  SignUpView.swift
//  CS125_NutriUs
//
//  Created by Max Doan on 2/9/21.
//

import SwiftUI
import Firebase


let color = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0)

typealias userCreated = (_ userCreated:Bool) -> Void
var userIdGlobal: String? = ""

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
            
            SecureField("Password (6+ chars)", text: $password)
                .padding()
                .background(lightGrey)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            NavigationLink(destination: CreateProfileView(userId: self.$userId, email: self.$email), tag: 1, selection: $selection) {
                Button(action: {
                    print("Before Signup, uid is", userId as Any)
                    // use Closure technique to wait for Firebase
                    signUp(email: email, password: password, completionHandler: { (userCreated) in
                        if userCreated {
                            userId = userIdGlobal
                            print("Out of Signup, uid is", userId as Any)
                            self.selection = 1
                        }
                    })
                }) {
                    SignupButtonContent()
                    }
                }
        }
    }
}
//}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

// sign up with closure
func signUp(email: String, password: String, completionHandler: @escaping userCreated) {
    var uid: String? = nil
    Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
        if err != nil {
            print("Error creating user, uid is nil")
            print(err!.localizedDescription)
        } else {
            uid = result!.user.uid
            print("SUCESS, uid is", uid!)
            // using global variable here so
            userIdGlobal = uid
            completionHandler(true)
        }
    }
}
