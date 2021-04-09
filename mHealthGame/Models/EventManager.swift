//
//  EventManger.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 2/3/2564 BE.
//

import EventKit

public class EventManager{
    static let shared = EventManager()
    var eventStore = EKEventStore()
    
    public func getYesterdayEvent(){
        // Get the appropriate calendar.
        let calendar = Calendar.current
        
        // Create the start date components
        var oneDayAgoComponents = DateComponents()
        oneDayAgoComponents.day = -1
        let oneDayAgo = calendar.date(byAdding: oneDayAgoComponents, to: Date())
        
        // Create the end date components.
        var oneYearFromNowComponents = DateComponents()
        oneYearFromNowComponents.year = 1
        let oneYearFromNow = calendar.date(byAdding: oneYearFromNowComponents, to: Date())
        
        // Create the predicate from the event store's instance method.
        var predicate: NSPredicate? = nil
        if let anAgo = oneDayAgo {
            predicate = eventStore.predicateForEvents(withStart: anAgo, end: Date(), calendars: nil)
        }
        
        // Fetch all events that match the predicate.
        var events: [EKEvent]? = nil
        if let aPredicate = predicate {
            events = eventStore.events(matching: aPredicate)
            if events != nil {
                for event in events! {
                    print("title: \(event.title!)")
                    print("startime: \(event.startDate!)")
                    print("endtime: \(event.endDate!)")
                }
            }
        }
    }
    
    public func getTodayEvent(completion: @escaping([EKEvent]) -> Void){
        let calendar = Calendar.current
        let dateTo = calendar.date(byAdding: .day, value: 1, to: Date())
        let predicate = eventStore.predicateForEvents(withStart: Date(), end: dateTo!, calendars: nil)
        
        var events: [EKEvent]? = nil
        events = eventStore.events(matching: predicate)
        if events != nil{
            completion(events!)
        }
    }
}
