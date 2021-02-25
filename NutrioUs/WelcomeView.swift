//
//  WelcomeView.swift
//  NutrioUs
//
//  Created by Annie Vu on 2/14/21.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {

        NavigationView() {
            VStack(alignment: .center,spacing: 20) {
                Text("NutriosUs")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 15.0)
                Text("Our Health in Our Hands")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.bottom, 100.0)
            NavigationLink(destination: LogInView()) {
                    LoginButtonContent()
                                       }
            
            NavigationLink(destination: SignUpView()) {
                    SignupButtonContent()
                                       }
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

struct SignupButtonContent : View {
    var body: some View {
        return Text("SIGN UP")
            .font(.headline)
            .foregroundColor(.white)
            .frame(width: 220, height: 40)
            .background(Color.blue)
            .cornerRadius(5.0)
            .padding(.horizontal, 50)
    }
}


struct LoginButtonContent : View {
    var body: some View {
        return Text("LOG IN")
            .font(.headline)
            .foregroundColor(.white)
            .frame(width: 220, height: 40)
            .background(Color.blue)
            .cornerRadius(5.0)
    }
}
