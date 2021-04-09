//
//  NotificationSettingViewController.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 3/3/2564 BE.
//

import UIKit

class NotificationSettingViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var setPreference: UIButton!
    @IBOutlet weak var demo: UIButton!
    
    override func viewDidLoad() {
        setupTitleLabel()
        
        DatabaseManager.shared.getNotificationPreference { (time) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let date = dateFormatter.date(from: time)
            self.timePicker.date = date!
        }
        timePicker.datePickerMode = .time
        timePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        setPreference.setTitle("Set Preference", for: .normal)
        setPreference.addTarget(self, action: #selector(setTime), for: .touchUpInside)
        demo.setTitle("demo", for: .normal)
        demo.addTarget(self, action: #selector(tap), for: .touchUpInside)
    }
    
    func setupTitleLabel (){
        let title = "Notification Preference"
        let attributedText = NSMutableAttributedString(string: title,attributes:
                            [NSAttributedString.Key.font: UIFont.init(name:"MavenPro-SemiBold",size: 28)!,NSAttributedString.Key.foregroundColor: UIColor.black])
        titleLabel.attributedText = attributedText
    }
    
    @objc func tap(){
        self.performSegue(withIdentifier: "gogo", sender: self)
    }
    
    @objc func setTime(){
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = DateFormatter.Style.short
        let strDate = timeFormatter.string(from: timePicker.date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        let date = dateFormatter.date(from: strDate)
        dateFormatter.dateFormat = "HH:mm"
        
        let date24 = dateFormatter.string(from: date!)
        print("24 hour: \(date24), 12hour : \(strDate)")
        
        dateFormatter.dateFormat = "HH"
        let hour = Int(dateFormatter.string(from: date!))
        
        dateFormatter.dateFormat = "mm"
        let minute = Int(dateFormatter.string(from: date!))
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        let title =  "Hey, how's your day?"
        let body = "It's time for your  daily exericise"
        
        DatabaseManager.shared.setNotificationPreference(time: date24)
        NotificationManager.shared.removeLocalNotification() // remove previous notification schedule
        NotificationManager.shared.sendNotification(dateComponents: dateComponents, title: title, body: body)
        
        let alert = UIAlertController(title: "Notification preference",message: "Notification has been set", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dissmiss",style: .default , handler: nil))
        self.present(alert, animated: true)
        
    }
}
