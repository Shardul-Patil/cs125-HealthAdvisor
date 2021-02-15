//
//  SignUpView.swift
//  CS125_NutriUs
//
//  Created by Max Doan on 2/9/21.
//

import SwiftUI

let color = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0)

struct SignUpView: View {
    
    @State var title: String =
    """
    NutrioUs
    Our Health in Our Hands
    """
    @State var email: String = ""
    @State var username: String = ""
    @State var password: String = ""
    @State var passwordConf: String = ""
    
    
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
            TextField("Username", text: $username)
                .padding()
                .background(lightGrey)
                .cornerRadius(5.0)
            SecureField("Password", text: $password)
                .padding()
                .background(lightGrey)
                .cornerRadius(5.0)
            SecureField("Password Confirmation ", text: $passwordConf)
                .padding()
                .background(lightGrey)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            Button(action: {print("Button tapped")}) {
                SignupButtonContent()
                       }
            
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
