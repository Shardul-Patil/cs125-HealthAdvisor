//
//  WelcomeView.swift
//  NutrioUs
//
//  Created by Annie Vu on 2/14/21.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
        Text("NutriosUs")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.top, 15.0)
        Button(action: {print("Button tapped")}) {
                    LoginButtonContent()
                           }
        Button(action: {print("Button tapped")}) {
                    SignupButtonContent()
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
            .frame(width: 220, height: 70)
            .background(Color.black)
            .cornerRadius(35.0)
            .padding(.horizontal, 50)
    }
}


struct LoginButtonContent : View {
    var body: some View {
        return Text("LOG IN")
            .font(.headline)
            .foregroundColor(.white)
            .frame(width: 220, height: 70)
            .background(Color.black)
            .cornerRadius(35.0)
    }
}


