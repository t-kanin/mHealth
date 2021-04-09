//
//  NotificationManager.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 3/3/2564 BE.
//

import UserNotifications

public class NotificationManager{
    static let shared = NotificationManager()
    let center = UNUserNotificationCenter.current()
    
    public func requestAuth(completion: @escaping(Bool) -> Void){
        center.requestAuthorization(options: [.alert, .sound]) { (granted, err) in
            if granted{ completion(true)}
            else{completion(false)}
        }
    }
    
    public func sendNotification(dateComponents: DateComponents, title: String, body: String){
        // create notification content
        let content = UNMutableNotificationContent()
        content.title = title // "Hey, how's your day"
        content.body = body// "It's time for your daily exercise. It helps reduce stress!!"
        
        // create the notification trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // create request
        let uuidString = "alertIdentifier"
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        //register the request
        center.add(request){ err in
            // handle any error
        }
        
    }
    
    public func sendNotificationNow(){
        let content = UNMutableNotificationContent()
        content.title = "Hey, how's your day"
        content.body = "It's time for your daily exercise. It helps reduce stress!!"
        let date = Date().addingTimeInterval(10)
        let dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "notificationNow", content: content, trigger: trigger)
        center.add(request) { (err) in
            if(err != nil){print(err as Any)}
        }
    }
    
    public func hasNotificationFired(completion: @escaping(Bool) -> Void){
        var  notificationFired = false
        center.getPendingNotificationRequests { (notifications) in
            for notification in notifications {
                if(notification.identifier  == "alertIdentifier"){ notificationFired = true}
            }
            completion(notificationFired)
        }
        
    }
    
    public func removeLocalNotification(){
        center.removeAllDeliveredNotifications() // To remove all delivered notifications
        center.removeAllPendingNotificationRequests()
    }
    
}
