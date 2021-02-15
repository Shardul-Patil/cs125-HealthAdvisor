//
//  ContentView.swift
//  CS125_NutriUs
//
//  Created by Kevin Pham on 2/9/21.
//

import SwiftUI

let lightGrey = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0)

struct LogInView: View {
    
    @State var username: String = ""
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
            TextField("Username", text: $username)
                .padding()
                .background(lightGrey)
                .cornerRadius(5.0)
            SecureField("Password", text: $password)
                .padding()
                .background(lightGrey)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            Button(action: {print("Button tapped")}) {
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
