//
//  HealthStore.swift
//  NutrioUs
//
//
//

//Source: YouTube  @azamsharp
import Foundation
import HealthKit

extension Date{
    static func mondayAt12AM() -> Date {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
}

class HealthStore{
    
    var healthStore: HKHealthStore?
    var query: HKStatisticsCollectionQuery?
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    func calculateSteps(completion: @escaping (HKStatisticsCollection?) -> Void){
        
        //setting up query
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        
        let anchorDate = Date.mondayAt12AM()
        
        let daily = DateComponents(day: 1)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        //creating query
        query = HKStatisticsCollectionQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: daily)
        
        query?.initialResultsHandler = { query, statisticsCollection, error in completion(statisticsCollection)
        }
        
        //executing query
        if let healthStore = healthStore, let query = self.query {
            healthStore.execute(query)
        }
        
        
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void){
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)! //here is where you can replace stepCount with any data field
        
        guard let healthStore = self.healthStore else { return completion(false)}
        
        healthStore.requestAuthorization(toShare: [], read: [stepType]) { (success, error) in completion(success)}
        
    }
}
