//
//  ContentView.swift
//  CS125_NutriUs
//
//  Created by Kevin Pham on 2/9/21.
//

import SwiftUI
import Firebase


let lightGrey = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0)

struct LogInView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var title: String =
    """
    NutrioUs
    Our Health in Our Hands
    """
    
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
            SecureField("Password", text: $password)
                .padding()
                .background(lightGrey)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            Button(action: {
                    logIn(email: email, password: password)}
            ) {
                LoginButtonContent()
                       }
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}


func logIn(email: String, password: String)
{
    Auth.auth().signIn(withEmail: email, password: password)
    //let user = Auth.auth().currentUser
    
    let user = Auth.auth().currentUser;
    if (user != nil) {
        //user is signed in
        let uid = user?.uid
        print("SUCCESS, uid is ")
        print(uid)
    } else {
      // No user is signed in.
    }
    

}
