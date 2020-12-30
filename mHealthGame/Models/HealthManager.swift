//
//  HealthManager.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 29/12/2563 BE.
//

import HealthKit


public class HealthManager{
    static let shared = HealthManager()
    var healthStore: HKHealthStore?
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    //MARK: - ask for user permission
    func requestAuthorization(completion: @escaping(Bool) -> Void){
        
        let flightsClimb = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.flightsClimbed)!
        let stepCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        let distance = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!
        
        guard  let healthStore = self.healthStore else {
            return completion(false)
        }
        
        healthStore.requestAuthorization(toShare: [], read: Set([flightsClimb,stepCount,distance])) { (success, error) in
            completion(success)
        }
        
    }
    
    // MARK: - GET NUMBER OF STAIRS CLIMB
    public func getTodayFlightsClimb(completion: @escaping(HKStatisticsCollection?) -> Void){
        guard let sampleType = HKCategoryType.quantityType(forIdentifier: .flightsClimbed) else {
            return
        }
        
        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        let daily = DateComponents(day: 1)
        
        let query = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate, intervalComponents: daily)
        
        query.initialResultsHandler = {
            query,result,error in
            
            completion(result)
            /*if let myresult = result {
                myresult.enumerateStatistics(from: startDate, to: Date()) { (statistics, value) in
                    if let count = statistics.sumQuantity() {
                        let val = count.doubleValue(for: HKUnit.count())
                        print("Total floor climb today is \(val) floors") // need to be pass to view controller
                    }
                }
            }*/
        }
        
        if healthStore != nil {
            healthStore!.execute(query)
        }
    }
    
    func calculateSteps(completion: @escaping(HKStatisticsCollection?) -> Void){
        
        let sampleType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        let daily = DateComponents(day: 1)
        
        let query = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate, intervalComponents: daily)
        
        query.initialResultsHandler = {query, result, error in
            completion(result)
        }
        
        if healthStore != nil {
            healthStore!.execute(query)
        }
    }
    
}
