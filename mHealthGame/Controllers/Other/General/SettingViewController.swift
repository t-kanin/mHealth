//
//  ProgressViewController.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 3/12/2563 BE.
//
import FirebaseDatabase
import FirebaseAuth
import SDWebImage
import UIKit
import EventKit

class SettingViewController: UIViewController{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var friendButton: UIButton!
    @IBOutlet weak var notificationPreferenceButton: UIButton!
    
    @IBOutlet weak var username: UILabel!
    
    /*demo demonstration*/
    @IBOutlet weak var sendNotificationNow: UIButton!
    @IBOutlet weak var sendNotificationLater: UIButton!
    
    var image: UIImage? = nil  
    var url : String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
        setupUI()
        
        notificationPreferenceButton.setTitle("Set notification preference", for: .normal)
        friendButton.setTitle("Friend list", for: .normal)
        sendNotificationNow.setTitle("Send notification after 10 second", for: .normal)
        sendNotificationNow.addTarget(self, action: #selector(didTapSendNotificationNow), for: .touchUpInside)
        sendNotificationLater.setTitle("Send notification with condition", for: .normal)
        sendNotificationLater.addTarget(self, action: #selector(didTapSendNotificationLater), for: .touchUpInside)
        
        username.text = ""
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUsernameLabel()
        let uid = AuthManager.shared.getUID()
        Database.database().reference().child("users").child(uid!).child("downloadURL").observeSingleEvent(of: .value, with: { (snapshot) in
            if let actualUrl = snapshot.value as? String{
                self.profilePic.sd_setImage(with: URL(string: actualUrl), placeholderImage: UIImage(systemName: "photo"), options:.continueInBackground, completed: nil)
            }
        })
    }
    
    private func setupUI(){
        setupTitleLabel()
        setupProfilePic()
        //setupLogoutButton() 
    }
    
    @objc private func didTapLogout(){
        
        AuthManager.shared.logout(){ success in
            if success {
                let loginVC = LoginViewController()
                loginVC.modalPresentationStyle = .fullScreen // user can't swipe it away
                self.present(loginVC, animated: true, completion: nil)
            }
            else {
                print("Sign oute failed")
            }
        }
    }
    
    /*demo function*/
    
    private func sentNotification(offsetHour: Int){
        
        var available = true
        
        fetchPreferenceTime { (hour, minute) in
            let date = Date()
            let calendar = Calendar.current
            let hour = hour + offsetHour
            let newDate = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: date)
            
            // fetch events
            let eventstore = EKEventStore()
            eventstore.requestAccess(to: .event) { (granted, err) in
                if granted{
                    EventManager.shared.getTodayEvent(completion: { (events) in
                        for event in events{
                            if(newDate! >= event.startDate && newDate! <= event.endDate && !event.isAllDay){available = false}
                        }
                        
                        if(!available){//print("time slot is occupied")
                            self.sentNotification(offsetHour: 2)
                        }
                        else{//print("time slot is free, notification sent at: \(newDate!)")
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Alert",message: "Notification sent at \(newDate!)", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Dissmiss",style: .cancel, handler: nil))
                                self.present(alert, animated: true)
                            }
                            self.setNotification(offsetHour: offsetHour)
                        }
                    })
                }
            }
            
        }
    }
    
    private func fetchPreferenceTime(completion: @escaping(Int, Int) -> Void){
        completion(13, 30)
    }
    
    private func setNotification(offsetHour: Int){
        NotificationManager.shared.requestAuth { (granted) in
            if granted{
                NotificationManager.shared.hasNotificationFired { (fired) in
                    if(!fired){
                        let title =  "Hey, how's your day?"
                        let body = "It's time for your  daily exericise"
                        var dateCompoents = DateComponents()
                        dateCompoents.hour = 17 + offsetHour
                        NotificationManager.shared.sendNotification(dateComponents: dateCompoents, title: title, body: body)
                    }
                }
            }
        }
    }
    
    @objc private func didTapSendNotificationNow(){
        NotificationManager.shared.sendNotificationNow()
    }
    
    @objc private func didTapSendNotificationLater(){
        sentNotification(offsetHour: 0)
    }
}
