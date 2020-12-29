//
//  HealthManager.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 29/12/2563 BE.
//

import HealthKit


public class HealthManager{
    static let shared = HealthManager()
    var healthStore = HKHealthStore()
    
    // MARK: - GET NUMBER OF STAIRS CLIMB
    
    public func getTodayStairsClimb(){
        guard let sampleType = HKCategoryType.quantityType(forIdentifier: .flightsClimbed) else {
            return
        }
        
        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        var interval = DateComponents()
        interval.day = 1
        
        let query = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate, intervalComponents: interval)
        
        query.initialResultsHandler = {
            query,result,error in
            
            if let myresult = result {
                myresult.enumerateStatistics(from: startDate, to: Date()) { (statistics, value) in
                    if let count = statistics.sumQuantity() {
                        let val = count.doubleValue(for: HKUnit.count())
                        print("Total floor climb today is \(val) floors") // need to be pass to view controller
                    }
                }
            }
        }
        healthStore.execute(query)
    }
    
}
