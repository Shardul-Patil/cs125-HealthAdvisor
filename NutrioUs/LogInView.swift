//
//  ContentView.swift
//  CS125_NutriUs
//
//  Created by Kevin Pham on 2/9/21.
//

import SwiftUI
import Firebase


let lightGrey = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0)
typealias userLogin = (_ userLogin:Bool) -> Void
var logInIdGlobal: String? = ""

struct LogInView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var title: String =
    """
    NutrioUs
    Our Health in Our Hands
    """
    @State var userId: String? = ""
    @State var selection: Int? = nil
    
    var body: some View
    {
        
        VStack(alignment: .center, spacing: 20) {
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
                .autocapitalization(.none)
            SecureField("Password", text: $password)
                .padding()
                .background(lightGrey)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            NavigationLink(destination: HomeView(userId: $userId), tag: 1, selection: $selection) {
                Button(action: {
                    print("Before login, uid is", userId as Any)
                    // use Closure technique to wait for Firebase
                    logIn(email: email, password: password, completionHandler: { (userLogin) in
                        if userLogin {
                            userId = logInIdGlobal
                            print("Out of Login, uid is", userId as Any)
                            self.selection = 1
                        }
                    })
                }) {
                    LoginButtonContent()
                    }
                }
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}

// Authenticates with Firebase
func logIn(email: String, password: String, completionHandler: @escaping userLogin)
{
    var uid: String? = nil
    Auth.auth().signIn(withEmail: email, password: password) { (result, err)
        in
        if err != nil {
            print("Error creating user, uid is nil")
            print(err!.localizedDescription)
        } else {
            uid = result!.user.uid
            print("LOGIN SUCCESS, uid is ", uid!)
            logInIdGlobal = uid
            completionHandler(true)
        }
    }
}
