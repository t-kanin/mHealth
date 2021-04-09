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
        let bmi = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMassIndex)!
        
        guard  let healthStore = self.healthStore else {
            return completion(false)
        }
        
        healthStore.requestAuthorization(toShare: [], read: Set([flightsClimb,stepCount,distance,bmi])) { (success, error) in
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
        }
        
        if healthStore != nil {
            healthStore!.execute(query)
        }
    }
    
    public func getTodayFlightsClimbDouble(completion: @escaping(Double?) -> Void){
        guard let sampleType = HKCategoryType.quantityType(forIdentifier: .flightsClimbed) else {
            return
        }
        
        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        let daily = DateComponents(day: 1)
        
        let query = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate, intervalComponents: daily)
        
        query.initialResultsHandler = {
            query,result,error in
            result?.enumerateStatistics(from: startDate, to: Date(), with: { (statistics, value) in
                let count = statistics.sumQuantity()?.doubleValue(for: .count())
                completion(count)
            })
        }
        
        if healthStore != nil {
            healthStore!.execute(query)
        }
    }
    
    func weeklyFlightClimb(completion: @escaping(Int?) -> Void){
        let samepleType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.flightsClimbed)!
        let sevendayAgo = Calendar.current.date(byAdding: DateComponents(day: -7), to: Date())!
        let startDate = Calendar.current.startOfDay(for: sevendayAgo)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsCollectionQuery.init(quantityType: samepleType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: startDate, intervalComponents: DateComponents(day: 1))
        
        query.initialResultsHandler = {query, result, error in
            result?.enumerateStatistics(from: startDate, to: Date(), with: { (statistics, value) in
                let count = statistics.sumQuantity()?.doubleValue(for: .count())
                if(count != nil){
                    completion(Int(count!))
                }
                else{
                    completion(0)
                }
            })
        }
        
        if healthStore != nil{
            healthStore!.execute(query)
        }
        
    }
    
    func totalWeeklyFlightClimb(completion: @escaping(Double?) -> Void){
        var averageFlightClimb = 0.0
        var counter = 0
        weeklyFlightClimb{ flightClimb in
            if(flightClimb != nil){
                counter += 1
                averageFlightClimb += Double(flightClimb!)
                if(counter == 7){
                    completion(averageFlightClimb/7)
                }
            }
        }
    }
  
    
    public func getDistanceTravel(completion: @escaping(HKStatisticsCollection?) -> Void){
        guard let sampleType = HKCategoryType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            return
        }
        
        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        let daily = DateComponents(day: 1)
        
        let query = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate, intervalComponents: daily)
        
        query.initialResultsHandler = {
            query,result,error in
            
            completion(result)
        }
        
        if healthStore != nil {
            healthStore!.execute(query)
        }
    }
    
    public func getDistanceTravelDouble(completion: @escaping(Int?) -> Void){
        guard let sampleType = HKCategoryType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            return
        }
        
        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        let daily = DateComponents(day: 1)
        
        let query = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate, intervalComponents: daily)
        
        query.initialResultsHandler = {
            query,result,error in
            result?.enumerateStatistics(from: startDate, to: Date(), with: { (statistics, value) in
                let count = statistics.sumQuantity()?.doubleValue(for: HKUnit.meter())
                if(count != nil){
                    completion(Int(count!))
                }
                else {completion(0)}
            })
        }
        
        if healthStore != nil {
            healthStore!.execute(query)
        }
    }
    
    func weeklyDistanceTravel(completion: @escaping(Int?) -> Void){
        let samepleType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!
        let sevendayAgo = Calendar.current.date(byAdding: DateComponents(day: -7), to: Date())!
        let startDate = Calendar.current.startOfDay(for: sevendayAgo)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsCollectionQuery.init(quantityType: samepleType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: startDate, intervalComponents: DateComponents(day: 1))
        
        query.initialResultsHandler = {query, result, error in
            result?.enumerateStatistics(from: startDate, to: Date(), with: { (statistics, value) in
                let count = statistics.sumQuantity()?.doubleValue(for: HKUnit.meter())
                if(count != nil){
                    completion(Int(count!))
                }
                else{
                    completion(0)
                }
            })
        }
        
        if healthStore != nil{
            healthStore!.execute(query)
        }
    }
    
    func totalWeeklyDistanceTravel(completion: @escaping(Double?) -> Void){
        var averageDistanceTravel = 0.0
        var counter = 0
        weeklyDistanceTravel { distanceTravel in
            if(distanceTravel != nil){
                counter += 1
                averageDistanceTravel += Double(distanceTravel!)
                if(counter == 7){
                    completion(averageDistanceTravel/7)
                }
            }
        }
    }
    
    func calculateStep(completion: @escaping(HKStatisticsCollection?) -> Void){
        
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
    
    func calculateStepDouble(completion: @escaping(Double?) -> Void){
        
        let sampleType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        let daily = DateComponents(day: 1)
        
        let query = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate, intervalComponents: daily)
        
        query.initialResultsHandler = {query, result, error in
            result?.enumerateStatistics(from: startDate, to: Date(), with: { (statistics, value) in
                let count = statistics.sumQuantity()?.doubleValue(for: .count())
                completion(count)
            })
        }
        
        if healthStore != nil {
            healthStore!.execute(query)
        }
    }
    
    func weeklyStepCount(completion: @escaping(Int?) -> Void){
        let samepleType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        let sevendayAgo = Calendar.current.date(byAdding: DateComponents(day: -7), to: Date())!
        let startDate = Calendar.current.startOfDay(for: sevendayAgo)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsCollectionQuery.init(quantityType: samepleType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: startDate, intervalComponents: DateComponents(day: 1))
        
        query.initialResultsHandler = {query, result, error in
            result?.enumerateStatistics(from: startDate, to: Date(), with: { (statistics, value) in
                let count = statistics.sumQuantity()?.doubleValue(for: .count())
                if(count != nil){
                    completion(Int(count!))
                }
                else{
                    completion(0)
                }
            })
        }
        
        if healthStore != nil{
            healthStore!.execute(query)
        }
        
    }
    
    func totalWeeklyStepCount(completion: @escaping(Double?) -> Void){
        var averageStepCount = 0.0
        var counter = 0
        weeklyStepCount { stepcount in
            if(stepcount != nil){
                counter += 1
                averageStepCount += Double(stepcount!)
                if(counter == 7){
                    completion(averageStepCount/7)
                }
            }
        }
    }
    
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
