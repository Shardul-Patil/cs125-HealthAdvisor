//
//  WelcomeView.swift
//  NutrioUs
//
//  Created by Annie Vu on 2/14/21.
//

import SwiftUI
import HealthKit

struct WelcomeView: View {
    
    
    //start of Health App Access
    private var healthStore: HealthStore? //wrapper
    
    init(){
        healthStore = HealthStore()
    }
    
    
    private func updateUIFromStatistics(statisticsCollection: HKStatisticsCollection){
        let endDate = Date()
        
        
        statisticsCollection.enumerateStatistics(from: endDate, to: endDate) { (statistics, stop) in
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            
            let returnCount = Int(count ?? 0)
            
            print("todays daily steps are: ")
            print(returnCount)
            
        }
    }
    //end of health App Access
    
    
    
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

        }.navigationViewStyle(StackNavigationViewStyle())
        
        
        //HealthKit Access Authorization
        //Source: YouTube  @azamsharp
        .onAppear {
            if let healthStore = healthStore {
                healthStore.requestAuthorization {success in
                    if success{
                        healthStore.calculateSteps{statisticsCollection in
                            if let statisticsCollection = statisticsCollection{
                                //update UI with statisticsCollection
                                //print(statisticsCollection)
                                //if user authorizes access to the health app, it will fetch data inside uppdateUIFromStatistics when this view loads
                                updateUIFromStatistics(statisticsCollection: statisticsCollection)
                            }
                        }
                    }
                    
                }
            }
        }
        //HealthKit Access Authorization Done
        
        
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
